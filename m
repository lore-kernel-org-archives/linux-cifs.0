From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: Access samba share which underlying storage is very slow
Date: Tue, 13 Dec 2016 11:23:07 -0600
Message-ID: <CAH2r5ms08XDuGowmqySdwhg6PqeFm7ipKj9Za1QJTC41jUYQUg@mail.gmail.com>
References: <CY4PR10MB1591B4B85ED8A29DE16CA5D7E49B0@CY4PR10MB1591.namprd10.prod.outlook.com>
 <CAH2r5mszkDE9pEF3D-Qsv0ek=n1SkpBRsm9ZdipgyFqUA8n=4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mszkDE9pEF3D-Qsv0ek=n1SkpBRsm9ZdipgyFqUA8n=4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Tue, Dec 13, 2016 at 11:20 AM
Subject: Re: Access samba share which underlying storage is very slow
To: "Wang, Zhiye" <Zhiye.Wang-gYDOmNCWHYlWk0Htik3J/w@public.gmane.org>
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


there is a "hard" mount option and the "echo" timeout can be adjusted on mo=
unt

On Tue, Dec 13, 2016 at 7:35 AM, Wang, Zhiye <Zhiye.Wang-gYDOmNCWHYlWk0Htik3J/w@public.gmane.org> wrot=
e:
>
> Dear all,
>
> I use Samba to share FUSE based file system which underlying storage is v=
ery slow sometimes (not always). Read/Write/Open sometimes may take several=
 minutes. And especially, "write" must be in sequential manner. And "write =
to file" cannot break in the middle of a file (much like tape).
>
> All that are ok for Samba, but it seems to be a problem for CIFS on clien=
t side. It seems operations timeout are all hardcoded, and cannot be adjust=
ed during mount. After timeout, CIFS client will reconnect and then resume =
"write" from where is broken (but this is not acceptable for my case).
>
> Is there a way to make CIFS client block at slow operations without timeo=
ut?
>
>
> Thanks
> Mike
>
>



--=20
Thanks,

Steve



--=20
Thanks,

Steve
