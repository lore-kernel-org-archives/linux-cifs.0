From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 1/7] fcntl: Introduce new O_DENY* open flags
Date: Thu, 28 Feb 2013 07:59:28 -0800
Message-ID: <CACyXjPw7eEabP-77YpPz2eOtGWsJNbTEVF968iiWxgamOsbkuA@mail.gmail.com>
References: <1362065133-9490-1-git-send-email-piastry@etersoft.ru>
	<1362065133-9490-2-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362065133-9490-2-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Feb 28, 2013 at 7:25 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =
wrote:
> This patch adds 4 flags:
> 1) O_DENYREAD that doesn't permit read access,
> 2) O_DENYWRITE that doesn't permit write access,
> 3) O_DENYDELETE that doesn't permit delete or rename,
> 4) O_DENYMAND that enables O_DENY* flags checks.
>
> Network filesystems CIFS, SMB2.0, SMB3.0 and NFSv4 have such flags -
> this change can benefit cifs and nfs modules as well as Samba and
> NFS file servers. These flags are only take affect for opens with
> O_DENYMAND flags - there is no impact on native Linux opens.

Isn't there a problem of races here? What if another person already
has the file open for WRITE and the CIFS server needs to open it with
DENY WRITE?

What happens if the CIFS server opens the file, but before it can
issue the DENY WRITE someone else opens it for write?

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
