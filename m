From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: The MID value 0xFFFF for CIFS ...
Date: Sun, 5 Aug 2012 12:54:54 -0700
Message-ID: <CACyXjPw4++WPF-UH-0LQHUQom0dA_dob6W_UP6=7B=0XVRy7Ng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi folks,

[MS-CIFS] in section 2.2.1.6.2 says, in part:

---------------
The value 0xFFFF MUST NOT be used as a valid MID. All other possible
values for MID, including
zero (0x0000), are valid. The value 0xFFFF is used in an OpLock Break
Notification request,
which is an SMB_COM_LOCKING_ANDX Request (section 2.2.4.32.1) sent
from the server.
---------------

However, in smb1ops.c:cifs_get_next_mid I do not see where a MID value
of 0xFFFF is skipped.

Perhaps it is done somewhere else that I have not found, and if so,
could someone point it out to me?

--
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
