From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: mark CONFIG_CIFS_NFSD_EXPORT as BROKEN
Date: Mon, 23 May 2011 08:54:59 -0500
Message-ID: <BANLkTim2QV5YPtSCJ6=79=2XNRUOEa976A@mail.gmail.com>
References: <1306065324-24604-1-git-send-email-jlayton@redhat.com>
	<20110522115938.GA27941@infradead.org>
	<20110522081707.72cce108@corrin.poochiereds.net>
	<BANLkTim_K__5bqJG5snk+Bb+CW5dB70aQA@mail.gmail.com>
	<20110523071208.5dc935f8@corrin.poochiereds.net>
	<BANLkTikRqxGo3mm7h3w3-JL+Si6ZJYGPZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikRqxGo3mm7h3w3-JL+Si6ZJYGPZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, May 23, 2011 at 8:42 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> On Mon, May 23, 2011 at 6:12 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On Sun, 22 May 2011 20:12:04 -0500
>> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>>> On Sun, May 22, 2011 at 7:17 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
>>> > On Sun, 22 May 2011 07:59:38 -0400
>>> > Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
>>> >
>>> >> On Sun, May 22, 2011 at 07:55:24AM -0400, Jeff Layton wrote:
>>> >> > This will never work properly with CIFS, as the protocol has n=
o ability
>>> >> > whatsoever for looking up files by filehandle. It *might* be p=
ossible to
>>> >> > eventually do this with SMB2, but that remains to be seen.
>
> Shirish had done some experiments (and AFAIK has a small patch
> that fixed NFS export over CIFS which works, with the usual restricti=
ons
> about having to return ESTALE if the NFS client tries to access
> an inode which has been flushed from the cache on the server side).
>
>>> For nfs v3 clients that can't handle ESTALE, we are probably
>>> stuck with having to wait for Samba to implement the flag
>> Flag?
>
> NTCreateX: =A0FILE_OPEN_BY_FILE_ID
>
> IIRC Shirish verified that the Windows client will emit this flag, bu=
t their
> server had not gotten around to implementing it (although Samba could
> implement it now that their is an open-by-handle syscall).

Steve, I am not sure whether Windows client would emit this flag or not=
=2E
This is the failure on the Windows client with a test program.

The very same program works fine on the Windows server i.e. the API
is OK with a local program opening a local file by fileid but I think W=
indows
client does not even transmit such a request to the server.

 ULONG status =3D NtCreatefile(&f, GENERIC_ALL, &oa, iosb, NULL,
=46ILE_ATTRIBUTE_NORMAL, FILE_SHARE_READ | FILE_SHARE_WRITE, FILE_OPEN,
=46ILE_OPEN_BY_FILE_ID | FILE_NON_DIRECTORY_FILE, NULL, 0);

returns error status: C0000008, handle: 0

if the file is remote but no error if the file is local.

>
>
>
> --
> Thanks,
>
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
