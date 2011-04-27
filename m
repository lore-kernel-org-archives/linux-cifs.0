From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Don't offer NFS export in Kconfig if nfsd is not enabled
Date: Wed, 27 Apr 2011 09:58:47 -0500
Message-ID: <BANLkTi=BAR9U2PsB+ykBk_WdRB0XdKdndg@mail.gmail.com>
References: <1303914147-23012-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	<20110427102920.09caae0e@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mark Brown <broonie-yzvPICuk2AATkU/dhu1WVueM+bqZidxxQQ4Iyu8u01E@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110427102920.09caae0e-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Apr 27, 2011 at 9:29 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Wed, 27 Apr 2011 15:22:27 +0100
> Mark Brown <broonie-yzvPICuk2AATkU/dhu1WVueM+bqZidxxQQ4Iyu8u01E@public.gmane.org> wrote:
>
>> There's no point in supporting NFS export of filesystems if we don't=
 have
>> nfsd in the first place.
>>
>> Signed-off-by: Mark Brown <broonie-yzvPICuk2AATkU/dhu1WVueM+bqZidxxQQ4Iyu8u01E@public.gmane.org>
>> ---
>> =A0fs/cifs/Kconfig | =A0 =A02 +-
>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
>> index 75c47cd..61e5f95 100644
>> --- a/fs/cifs/Kconfig
>> +++ b/fs/cifs/Kconfig
>> @@ -175,6 +175,6 @@ config CIFS_SMB2
>>
>> =A0config CIFS_NFSD_EXPORT
>> =A0 =A0 =A0 =A0 bool "Allow nfsd to export CIFS file system (EXPERIM=
ENTAL)"
>> - =A0 =A0 =A0 depends on CIFS && EXPERIMENTAL
>> + =A0 =A0 =A0 depends on CIFS && NFSD && EXPERIMENTAL
>> =A0 =A0 =A0 =A0 help
>> =A0 =A0 =A0 =A0 =A0Allows NFS server to export a CIFS mounted share =
(nfsd over cifs)
>
> This looks ok, though I'd still prefer to see all of the nfs exportin=
g
> code removed. The cifs protocol has no consistent way to look up inod=
es
> by filehandle and so it simply can never work.
>
> Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Patch seems reasonable



--=20
Thanks,

Steve
