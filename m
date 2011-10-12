From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: review of patch "cifs: untangle server->maxBuf and CIFSMaxBufSize"
Date: Wed, 12 Oct 2011 14:06:13 -0500
Message-ID: <CAH2r5mvG_NTvnjAhxZWMnkBbpMXqLoJaBWiyqnA5DOdABCTmkw@mail.gmail.com>
References: <CAH2r5mug5PmrbhmAazv62xQGgFmH8TjZEL84WOnbvO59hccPwQ@mail.gmail.com>
	<20111012132510.68c3d986@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111012132510.68c3d986-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 12, 2011 at 12:25 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> On Wed, 12 Oct 2011 12:15:29 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Reviewing changes to fs/cifs/connect.c in
>> http://git.samba.org/?p=3Djlayton/linux.git;a=3Dcommit;h=3Db82a25501=
cb18b86fd247da15c886762fdc5404c
>>
>> It looks like the following logic changes from setting rsize to what
>> the server claims it can support (negotiated maxBuf) to what our
>> maximum buffer size is:
>>
>> @@ -3130,8 +3130,7 @@ try_mount_again:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(DBG2, "no very large read suppo=
rt, rsize now 127K");
>> =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 if (!(tcon->ses->capabilities & CAP_LARGE_READ_X))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->rsize =3D min(cifs_sb->rsize,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(tcon->=
ses->server->maxBuf - MAX_CIFS_HDR_SIZE));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->rsize =3D min(cifs_sb->rsize,=
 CIFSMaxBufSize);
>>
>>
>> Is that what we want?
>>
>
> I think so, yes. That's part of untangling the mess.
>
> According to the protocol docs, the server should only be bound by th=
e
> client's MaxBufSize for reads. Therefore, the maxBuf advertised by th=
e
> server should have no bearing on the rsize.

That may be true, but the following phrase in the description of
SMB Read (not ReadX) worried me:

"If a read requests more data than can be placed in a message of
MaxBufferSize for the SMB
connection, the server MUST abort the connection to the client."



--=20
Thanks,

Steve
