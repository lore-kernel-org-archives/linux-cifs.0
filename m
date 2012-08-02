From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Handling of Connection.CommandSequenceWindow for SMB2 ...
Date: Thu, 2 Aug 2012 06:49:52 -0700
Message-ID: <CACyXjPzNCR-uF8wUr1Mw-H9S6rma4iLDBW1r01ooncCh=AKHvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi folks,

I have not been able to find where Connection.CommandSequenceWindow is
handled in the smb2 code.

Perhaps I am looking in the wrong repos or the wrong branch. Can
someone point me to where it is?

I am referring to [MS-SMB2] section 3.3.1.7 (dated July 5, 2012.) and
the other references to the CommandSequenceWindow. I would have
thought that it might be dealt with in the demultiplexing thread. It
does not seem possible to avoid explicitly storing the
CommandSequenceWindow because of the potential for out-of-order
receipt of SMBs.

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
