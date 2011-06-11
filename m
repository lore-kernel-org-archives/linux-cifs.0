From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix kernel crash on simultaneous mount/umount calls
Date: Sat, 11 Jun 2011 18:00:25 +0400
Message-ID: <BANLkTim==J7=-bEz1pahhKuxFdMFe2BnWg@mail.gmail.com>
References: <1307622570-7141-1-git-send-email-piastryyy@gmail.com>
	<20110609124043.GA9621@infradead.org>
	<BANLkTikmfKtDxG_6qg+6JiCT2FzF1FFfQg@mail.gmail.com>
	<20110611094314.GA6217@infradead.org>
	<20110611111253.GD11521@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110611111253.GD11521-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/6/11 Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>:
> On Sat, Jun 11, 2011 at 05:43:14AM -0400, Christoph Hellwig wrote:
>
>> Ok, if we look at sb-private data in the sget callsbacks it seems li=
ke
>> the clreanup for those does indeed need to be done in ->kill_sb. =A0=
I have
>> to say I really hate it, and the culprit is that we call the sget te=
st
>> callback is called before we call grab_super in sget, that is we don=
't
>> protect against filesystems going away. =A0I suspect that is the rea=
l
>> problem here.
>
> grab_super() is *heavy* and having to undo it even once means that we=
 need to
> rescan. =A0Sorry, test() has to be callable without that.
>

In this case, I think we should follow NFS strategy and apply my patch
as a workaround. Thoughts?

--=20
Best regards,
Pavel Shilovsky.
