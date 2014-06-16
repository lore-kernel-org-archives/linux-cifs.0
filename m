From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] fs/cifs: fix regression in cifs_create_mf_symlink()
Date: Mon, 16 Jun 2014 17:07:56 -0500
Message-ID: <CAH2r5mt+r3ab_gxZAYhF=buL3s3rz=dx9yEUyFh20mM9Yg08Ag@mail.gmail.com>
References: <1402394606-7910-1-git-send-email-bb@sernet.de> <539EF5FD.5000307@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?UTF-8?Q?Bj=C3=B6rn_Baumbach?= <bb@sernet.de>,
	Steve French <sfrench@samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
	Pavel Shilovsky <piastryyy@gmail.com>
To: "Stefan (metze) Metzmacher" <metze@samba.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <539EF5FD.5000307@samba.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Although I have merged this into cifs-2.6.git for-next, in my testing
I am also seeing this fail with vers=3D3.0 (and probably 2.0 and 2.1) s=
o
I would like to fix that too (and mfsymlinks may be at least as
important there)

On Mon, Jun 16, 2014 at 8:49 AM, Stefan (metze) Metzmacher
<metze@samba.org> wrote:
> Hi Steve,
>
> any comments on this? How can we get this fixed upstream?
>
> Thanks!
> metze
>
> Am 10.06.2014 12:03, schrieb Bj=C3=B6rn Baumbach:
>> commit d81b8a40e2ece0a9ab57b1fe1798e291e75bf8fc
>> ("CIFS: Cleanup cifs open codepath")
>> changed disposition to FILE_OPEN.
>>
>> Signed-off-by: Bj=C3=B6rn Baumbach <bb@sernet.de>
>> Signed-off-by: Stefan Metzmacher <metze@samba.org>
>> Reviewed-by: Stefan Metzmacher <metze@samba.org>
>> Cc: <stable@vger.kernel.org> # v3.14+
>> Cc: Pavel Shilovsky <piastry@etersoft.ru>
>> Cc: Steve French <sfrench@samba.org>
>> ---
>>  fs/cifs/link.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
>> index 264ece7..68559fd 100644
>> --- a/fs/cifs/link.c
>> +++ b/fs/cifs/link.c
>> @@ -374,7 +374,7 @@ cifs_create_mf_symlink(unsigned int xid, struct =
cifs_tcon *tcon,
>>       oparms.cifs_sb =3D cifs_sb;
>>       oparms.desired_access =3D GENERIC_WRITE;
>>       oparms.create_options =3D create_options;
>> -     oparms.disposition =3D FILE_OPEN;
>> +     oparms.disposition =3D FILE_CREATE;
>>       oparms.path =3D path;
>>       oparms.fid =3D &fid;
>>       oparms.reconnect =3D false;
>>
>



--=20
Thanks,

Steve
