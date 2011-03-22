From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: Use invalidate_inode_pages2 instead of
 invalidate_remote_inode (try #4)
Date: Tue, 22 Mar 2011 11:46:54 -0500
Message-ID: <AANLkTikg4WQrguR_cvvkxXZ8XomO=3ySjPzT67yO_cvk@mail.gmail.com>
References: <1300229732-4902-1-git-send-email-piastry@etersoft.ru>
	<20110322074233.546d4553@corrin.poochiereds.net>
	<AANLkTinGszmNsqFbf5vVstXfEsf5sh+SUZiFexjgBxjY@mail.gmail.com>
	<20110322080409.23461155@corrin.poochiereds.net>
	<AANLkTin_dHLJLpZxnmbCM=ukg7_xBi7YHg_YRaaYUmkj@mail.gmail.com>
	<20110322111711.55365655@corrin.poochiereds.net>
	<AANLkTikMbyg6FK7tgcb-a9kc_2r-rToA2x0AvY_KHQUw@mail.gmail.com>
	<20110322123549.022e590e@corrin.poochiereds.net>
	<AANLkTim=J7Y-b07HHKypfxgXL=jpgVVaZ1hn2201Amny@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTim=J7Y-b07HHKypfxgXL=jpgVVaZ1hn2201Amny-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 22, 2011 at 11:42 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> Isn't there a lock across lseek?
>
>>> but how could we have PageDirty? =A0We just did filemap_write_and_w=
ait
>>> (unless some private mmap case where it may be ok?).
>>>
>>
>> Nothing prevents the page from being redirtied after writeback.

If it is redirtied, we immediately do a filemap_fdatawrite anyway (in
the write/aio_write path) so there isn't a delay in writing data to
the server.



--=20
Thanks,

Steve
