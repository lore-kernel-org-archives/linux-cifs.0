From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Access samba share which underlying storage is very slow
Date: Wed, 14 Dec 2016 17:27:36 -0600
Message-ID: <CAH2r5mu=ZxY2TfOEcopxuCJgEVbuo0i0mDCbzJ2yTzJi-=7tWg@mail.gmail.com>
References: <CY4PR10MB1591B4B85ED8A29DE16CA5D7E49B0@CY4PR10MB1591.namprd10.prod.outlook.com>
 <CAH2r5mszkDE9pEF3D-Qsv0ek=n1SkpBRsm9ZdipgyFqUA8n=4w@mail.gmail.com> <CY4PR10MB159109A9F879DD7834B93FBEE49A0@CY4PR10MB1591.namprd10.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: "Wang, Zhiye" <Zhiye.Wang-gYDOmNCWHYlWk0Htik3J/w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR10MB159109A9F879DD7834B93FBEE49A0-871WlKnvxleuFQuCF5OPf4Ca9M1JiERdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Yes - you are probably correct since echo_interval tunable was added
in the last year or so.

Reconnection logic has been much improved over the past three years,
so make sure you are not running a very old kernel (or ask your distro
to backport fixes) - there are lots of corner cases in reconnect.

Note that very old cifs had an "echo retries" module load parm (for
cifs.ko) that could be increased from its default of 5 (or reconnect
could be disabled by setting to zero).   The echo interval was 60
seconds.

Note that even this far back cifs.ko intentionally did not timeout on
certain (potentially very slow) operations (writes that are past end
of file was one example)


On Wed, Dec 14, 2016 at 8:05 AM, Wang, Zhiye <Zhiye.Wang-gYDOmNCWHYlWk0Htik3J/w@public.gmane.org> wrot=
e:
> Thank you for the information.
>
> "hard" seems a good option for me. I will do more test.
>
> As to "echo" timeout, are you referring "echo_interval"? It seems this op=
tion was implemented pretty late, and only most recent Linux distributions =
include its support.
>
> Besides that, I have already configured samba server to serve "echo" requ=
est in separated process("async smb echo handler =3D yes", so "echo" server=
 will not be blocked by "open/read/write" operations), but I can still see =
warning below on client side:
>
> [620422.570128] CIFS VFS: Server 10.57.33.134 has not responded in 120 se=
conds. Reconnecting...
>
>
> Do you have any suggestion on this?
>
>
> Thanks
> Mike
>
>
>
>
>
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2016=E5=B9=B412=E6=9C=8814=E6=97=A5=
 1:20
> =E6=94=B6=E4=BB=B6=E4=BA=BA: Wang, Zhiye
> =E6=8A=84=E9=80=81: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> =E4=B8=BB=E9=A2=98: Re: Access samba share which underlying storage is ve=
ry slow
>
>
> there is a "hard" mount option and the "echo" timeout can be adjusted on =
mount
>
>
> On Tue, Dec 13, 2016 at 7:35 AM, Wang, Zhiye  <Zhiye.Wang-gYDOmNCWHYlWk0Htik3J/w@public.gmane.org> w=
rote:
>  Dear all,
>
> I use Samba to share FUSE based file system which underlying storage is v=
ery slow sometimes (not always). Read/Write/Open sometimes may take several=
 minutes. And especially, "write" must be in sequential manner. And "write =
to file" cannot break in the middle  of a file (much like tape).
>
> All that are ok for Samba, but it seems to be a problem for CIFS on clien=
t side. It seems operations timeout are all hardcoded, and cannot be adjust=
ed during mount. After timeout, CIFS client will reconnect and then resume =
"write" from where is broken (but  this is not acceptable for my case).
>
> Is there a way to make CIFS client block at slow operations without timeo=
ut?
>
>
> Thanks
> Mike
>
>
>
>
>
>
>  --
>
> Thanks,
>
> Steve



--=20
Thanks,

Steve
