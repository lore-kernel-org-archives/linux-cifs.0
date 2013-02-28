From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH v3 1/7] fcntl: Introduce new O_DENY* open flags
Date: Thu, 28 Feb 2013 21:56:22 +0400
Message-ID: <CAKywueQ8UZ4Vo6nZuvVwgXg_PLNmEByGpZrUhFNkDBkrAk48Tw@mail.gmail.com>
References: <1362065133-9490-1-git-send-email-piastry@etersoft.ru>
	<1362065133-9490-2-git-send-email-piastry@etersoft.ru>
	<CACyXjPw7eEabP-77YpPz2eOtGWsJNbTEVF968iiWxgamOsbkuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPw7eEabP-77YpPz2eOtGWsJNbTEVF968iiWxgamOsbkuA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/2/28 Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Thu, Feb 28, 2013 at 7:25 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>> This patch adds 4 flags:
>> 1) O_DENYREAD that doesn't permit read access,
>> 2) O_DENYWRITE that doesn't permit write access,
>> 3) O_DENYDELETE that doesn't permit delete or rename,
>> 4) O_DENYMAND that enables O_DENY* flags checks.
>>
>> Network filesystems CIFS, SMB2.0, SMB3.0 and NFSv4 have such flags -
>> this change can benefit cifs and nfs modules as well as Samba and
>> NFS file servers. These flags are only take affect for opens with
>> O_DENYMAND flags - there is no impact on native Linux opens.
>
> Isn't there a problem of races here? What if another person already
> has the file open for WRITE and the CIFS server needs to open it with
> DENY WRITE?

If another person already has the file open for WRITE, CIFS server can
successfully open it with DENYWRITE, because this DENY* behavior
affects only DENYMAND opens.

>
> What happens if the CIFS server opens the file, but before it can
> issue the DENY WRITE someone else opens it for write?

The same things - CIFS server will open and lock the file without problems.

-- 
Best regards,
Pavel Shilovsky.
