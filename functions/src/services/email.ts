import {createTransport} from "nodemailer";

// class EmailManager {

// }

interface SendEmailOptions {
  text: string;
  html: string;
  subject: string;
  recipientEmail: string;
}

class EmailService {
  private readonly fromAddress = "Excel Academy <no-reply@excelacademy.com>";

  private readonly transport = createTransport({
    host: "smtp.mailgun.org",
    port: 587,
    auth: {
      pass: "d92d63c7b4ab59a0c13d2234fa7b5c54-135a8d32-933d9bda",
      user: "postmaster@sandboxdf4ec0d2dbc946c2aee2536634244c24.mailgun.org",
    }
  });

  public async sendEmail(option: SendEmailOptions) {
    const info = await this.transport.sendMail({
      text: option.text,
      html: option.html,
      from: this.fromAddress,
      subject: option.subject,
      to: option.recipientEmail,
    });

    console.debug("Message info:", info);
  }
}

export default EmailService;
