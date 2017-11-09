From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cifs: fix return code when failing to rename a file onto a directory
Date: Thu, 09 Nov 2017 11:54:35 +0100
Message-ID: <87lgjfiuxg.fsf@suse.com>
References: <20171109051157.30814-1-lsahlber@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171109051157.30814-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Ronnie,

Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> +int
> +smb2_is_dir(const unsigned int xid, struct cifs_tcon *tcon,
> +	    __le16 *target_file)

I think I'd feel better if the actual result was an out parameter rather
than mixed with errors in the return value.

> +	if (rc)
> +		goto out;
> +
> +	rc = !!(le32_to_cpu(smb2_data->Attributes) & FILE_ATTRIBUTE_DIRECTORY);
> +
> +out:
> +	kfree(smb2_data);
> +	return rc;

I think this can hide EPERM (errno 1) errors.

Also it's too bad we have functions taking in utf16 params and some not
but that's a whole another story. I had this idea of introducing a path
struct and only serialize it at the very last moment which I'll try to
implement ..one day :)

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
