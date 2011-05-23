From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: mark CONFIG_CIFS_NFSD_EXPORT as BROKEN
Date: Mon, 23 May 2011 11:58:50 -0500
Message-ID: <BANLkTikpWQaYRbaTGs5WtZ8zWrL8jeeQZQ@mail.gmail.com>
References: <1306065324-24604-1-git-send-email-jlayton@redhat.com>
	<20110522115938.GA27941@infradead.org>
	<20110522081707.72cce108@corrin.poochiereds.net>
	<BANLkTim_K__5bqJG5snk+Bb+CW5dB70aQA@mail.gmail.com>
	<20110523071208.5dc935f8@corrin.poochiereds.net>
	<BANLkTikRqxGo3mm7h3w3-JL+Si6ZJYGPZQ@mail.gmail.com>
	<4DDA8BE6.8000001@plainjoe.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerald Carter <jerry-I3iY/6WR96Zg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DDA8BE6.8000001-I3iY/6WR96Zg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, May 23, 2011 at 11:31 AM, Gerald Carter <jerry-I3iY/6WR96Zg9hUCZPvPmw@public.gmane.org> wr=
ote:
> On 05/23/2011 08:42 AM, Steve French wrote:
>
>> Shirish had done some experiments (and AFAIK has a small patch
>> that fixed NFS export over CIFS which works, with the usual restrict=
ions
>> about having to return ESTALE if the NFS client tries to access
>> an inode which has been flushed from the cache on the server side).
>>
>>>> For nfs v3 clients that can't handle ESTALE, we are probably
>>>> stuck with having to wait for Samba to implement the flag
>>> Flag?
>>
>> NTCreateX: =A0FILE_OPEN_BY_FILE_ID
>>
>> IIRC Shirish verified that the Windows client will emit this flag, b=
ut their
>> server had not gotten around to implementing it (although Samba coul=
d
>> implement it now that their is an open-by-handle syscall).
>
> Hey Jeff/Steve,
>
> I found in [MS-CIFS] that says a server MUST return STATUS_NOT_SUPPOR=
TED
> for this option.
Yes - Microsoft has said that their servers do return
STATUS_NOT_SUPPORTED but this is not "MUST" in exactly the same sense
as in an IETF RFC, and the discussion I had with JRA was about servers
which support the Unix/POSIX extensions allowing this.



--=20
Thanks,

Steve
