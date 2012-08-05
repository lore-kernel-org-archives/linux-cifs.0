From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: These constants are ugly ...
Date: Sun, 5 Aug 2012 15:17:25 -0700
Message-ID: <CACyXjPxhb9JbL05fTdtqb_QPB3GgSG8AuqKatdvAAeAS3UJJ9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi folks,

This use of constants seems ugly:

                /* make sure we have enough to get to the MID */
                if (pdu_length < HEADER_SIZE(server) - 1 - 4) {
                        cERROR(1, "SMB response too short (%u bytes)",
                                pdu_length);
                        cifs_reconnect(server);
                        wake_up(&server->response_q);
                        continue;
                }

While the 4 is obvious, the 1 is not, and would seem to lead to
getting all but one byte in the case of SMB2 headers.

Why can't HEADER_SIZE be MIN_HEADER_SIZE or something like that and be
defined in smb?ops.c as the appropriate thing? In the case of CIFS, it
would be sizeof(struct smb_hdr) - 1 and in the case of SMB2 it would
be sizeof(struct smb2_hdr).

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
