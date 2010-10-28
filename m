From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 1/2] cifs: add kfree() on error path
Date: Wed, 27 Oct 2010 19:57:13 -0500
Message-ID: <AANLkTin48NsEA8OcL3Tt=5ygL5+mnMbpDMQkupUzC2NK@mail.gmail.com>
References: <20101027211932.GK6062@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101027211932.GK6062@bicker>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 27, 2010 at 4:19 PM, Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> We leak 256 bytes here on this error path.
>
> Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 45af003..06a006b 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1353,6 +1353,7 @@ static int cifs_writepages(struct address_space=
 *mapping,
> =A0 =A0 =A0 =A0if (!experimEnabled && tcon->ses->server->secMode &
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(SECMODE_SIGN_REQUIRED=
 | SECMODE_SIGN_ENABLED)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifsFileInfo_put(open_file);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(iov);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return generic_writepages(mapping, wbc=
);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0cifsFileInfo_put(open_file);

Yes. obviously correct.- merged.

--=20
Thanks,

Steve
