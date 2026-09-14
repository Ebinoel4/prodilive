import nodemailer from 'nodemailer';

const appUrl = String(process.env.APP_URL || '').replace(/\/$/, '');
const mailFrom = process.env.MAIL_FROM || process.env.SMTP_USER || 'PRODILIVE <no-reply@prodilive.com>';
const adminEmail = String(process.env.ADMIN_EMAIL || '').trim();

const transporter = process.env.SMTP_HOST ? nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: Number(process.env.SMTP_PORT || 587),
  secure: String(process.env.SMTP_SECURE || 'false') === 'true',
  auth: process.env.SMTP_USER ? { user: process.env.SMTP_USER, pass: process.env.SMTP_PASS } : undefined,
  connectionTimeout: 10000,
  greetingTimeout: 10000,
  socketTimeout: 10000
}) : null;

export const emailConfigured = Boolean(transporter && mailFrom);

const esc = (v='') => String(v).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const layout = (title, body) => `<!doctype html><html><body style="margin:0;background:#f5f3ee;font-family:Arial,sans-serif;color:#171717"><div style="max-width:620px;margin:32px auto;background:#fff;border:1px solid #e8e2d7;border-radius:16px;overflow:hidden"><div style="padding:24px 28px;border-bottom:1px solid #eee7dc"><strong style="font-size:22px;letter-spacing:.5px">PRODILIVE</strong></div><div style="padding:30px 28px"><h1 style="font-size:24px;margin:0 0 18px">${esc(title)}</h1>${body}<p style="margin-top:28px;color:#777;font-size:13px">This is an automated PRODILIVE email. Please do not reply to this message.</p></div><div style="padding:18px 28px;background:#faf9f6;color:#888;font-size:12px">${esc(appUrl)}</div></div></body></html>`;
const p = text => `<p style="line-height:1.65">${esc(text).replace(/\n/g,'<br>')}</p>`;

export function emailHtml(title, text, buttonText='', buttonPath='') {
  const button = buttonText && buttonPath ? `<p style="margin:24px 0"><a href="${esc(buttonPath.startsWith('http') ? buttonPath : appUrl + buttonPath)}" style="display:inline-block;padding:12px 18px;background:#151515;color:#fff;text-decoration:none;border-radius:8px">${esc(buttonText)}</a></p>` : '';
  return layout(title, p(text) + button);
}

export async function sendMail(to, subject, text, html=emailHtml(subject, text)) {
  if (!transporter || !to) return false;
  await transporter.sendMail({ from: mailFrom, to, subject, text, html });
  return true;
}

export function sendMailAsync(to, subject, text, html=emailHtml(subject, text)) {
  if (!transporter || !to) return;
  sendMail(to, subject, text, html).catch(e => console.error('Email send failed:', e.message));
}

export function sendAdminMail(subject, text, html=emailHtml(subject, text)) {
  if (!adminEmail) return;
  sendMailAsync(adminEmail, `PRODILIVE ADMIN — ${subject}`, text, html);
}

export const links = {
  dashboard: () => `${appUrl}/?page=dashboard`,
  login: () => `${appUrl}/?page=login`,
  reset: token => `${appUrl}/reset-password?token=${encodeURIComponent(token)}`,
  verify: token => `${appUrl}/api/auth/verify-email?token=${encodeURIComponent(token)}`
};

export function userNotificationHtml(title, body, meta={}) {
  const extra = Object.entries(meta).filter(([,v]) => v !== undefined && v !== null && v !== '').map(([k,v]) => `<tr><td style="padding:7px 0;color:#777">${esc(k)}</td><td style="padding:7px 0;text-align:right"><strong>${esc(v)}</strong></td></tr>`).join('');
  return layout(title, `${p(body)}${extra ? `<table style="width:100%;border-top:1px solid #eee;border-bottom:1px solid #eee;margin:18px 0">${extra}</table>` : ''}<p><a href="${esc(links.dashboard())}" style="display:inline-block;padding:12px 18px;background:#151515;color:#fff;text-decoration:none;border-radius:8px">Open PRODILIVE</a></p>`);
}
