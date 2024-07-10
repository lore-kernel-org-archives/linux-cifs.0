Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BB515E88
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jul 2024 19:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720640958; cv=none; b=g8773it6PD9XBmPG4lcedruGOBRVgpLdpIxC/5wc39flhHurREVW62mMf3jKg4OIr9VSC3di65tXD611x/M9t1WLU35X4g+Hep9JkuADlRmqND+lneewtJH7w+Ut+wCBNrNa5d0OebIzM7fyjnD7xqgTXeepySjAcJDbz2tPBrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720640958; c=relaxed/simple;
	bh=x27beICtFWq8wQpqGwB3JSa2YzO9rlxJ3m6NnHVoj64=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VzXfzvSbsIDhiWcgCnS622VlSZp2t+lutNy+h3PzpliWgn8ivCuy/VEBpaOsP59i/60H0OK5NntQhE2GBCxpAyK6ViWs0APmbZNXkGJ9dAuelnbZC+/ZUh3FC+JoAyy8m+cUknKKgryzR4a2tY8Wg6wGsssrud2rsyMKK1YI/2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cjvcfJHe; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cjvcfJHe"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-52ea3e499b1so152614e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 10 Jul 2024 12:49:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720640955; x=1721245755; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mn7tf1n9eqS4vdwHAMfIoIm/ajGZvR74ISU+VBQiKkM=;
        b=cjvcfJHe/yqDJgusB+LV7U0b0JY7qlD0rPG82qF/PM+bYCItPZAy/xPIfAQj2wUTZh
         TBTxqEiLDhXcm4ra2JN+l3toJzvkSfqkZcguD7tOeb/Act6DpIK4Dc5SrVo/rlCUxOH6
         7ZDQlFl1SVaqGzwRP8TuIbqh/xflcQn6ZcOznCYe7TqcZkGp7bTrvjHjQMg4lkzwXyP5
         ei0wGaZ0TPZE7ms3AIf/GM+rZNglsioZRW8QNvFMu3ZPq2E3IERMP0Yuh8stf7xZ41sM
         g9XBUz85JB+RY+E4sLetQLRAitfaAZkOM1dSaONVs1XBGi9NeZB7quNkzqHwNr+E7376
         PPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720640955; x=1721245755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mn7tf1n9eqS4vdwHAMfIoIm/ajGZvR74ISU+VBQiKkM=;
        b=ogjy9Z+o5ia4hfRUGLERyXheWaJ00eFN76XieVSijhiQS0pj0yTm4g7GmV3dLdM22g
         STaUtYCjcFCwjm0ihG3HUN1jqOLD4tEl9e5KrudB7WPUTilfabhEY+JMg5g8v2C3t+oA
         /kamuuDU9JTAV72co7LG6m/QzMpaonlkcgOBf361i/Dq5FDmdtgvAXMedY9wYIjMwrFY
         sUXQZhGOXFkAZwpHbR3Tox+KTzluKNMY0L8cKoaHsaDDz1mbNnHMmWL5mZ/RPfZhfZ5p
         C32dZHcmZI/34dR3IiFr8TChU6+9oTOFuY3wJ6sRrhX6lRVCMfdTlPHsWXS8YNkLWaYb
         XnDg==
X-Gm-Message-State: AOJu0YyWtZUZ6blvD4/F1Aa7maye/GcZ5/lZAkfXhVd6j/9HQn5afmIs
	QiWYI/3F5a9LThPz+COGFMmEraFP9srwgwxa6aX82OLm4fC7DGqjY7xBWzV2i4sVb9Zw1mUjkBQ
	lIATC9SZGUgQkkXBpSzf7rUPci+Y=
X-Google-Smtp-Source: AGHT+IEyaVajNPO+TUbI0u+tauTGQUtgoPcUomKHl5sHgI13fZAn9wJR+ra/wRSqzZFh/zaLJFpc/1fthi6vaH6v3aA=
X-Received: by 2002:ac2:4206:0:b0:52c:e030:1450 with SMTP id
 2adb3069b0e04-52eb99913a3mr3412098e87.14.1720640954762; Wed, 10 Jul 2024
 12:49:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240705204352.975013-1-profnandaa@gmail.com>
In-Reply-To: <20240705204352.975013-1-profnandaa@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 10 Jul 2024 14:49:03 -0500
Message-ID: <CAH2r5muZF19O4Atro_TjjiQsrhXT6fodZwwWuGskOxQwh8P=6A@mail.gmail.com>
Subject: Re: [PATCH] cifs-utils: smbinfo: add gettconinfo command
To: Anthony Nandaa <profnandaa@gmail.com>
Cc: linux-cifs@vger.kernel.org, stfrench@microsoft.com, sfrench@samba.org, 
	samba-technical@lists.samba.org, Pavel Shilovsky <pshilovsky@samba.org>, 
	Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Pavel,

looks good - I checked it out and tested it.  It can be helpful in
debugging server logs to have this information (about the tree id and
session id for a particular mount)

Can add my Tested-by and or Reviewed-by if you want

On Fri, Jul 5, 2024 at 3:44=E2=80=AFPM Anthony Nandaa <profnandaa@gmail.com=
> wrote:
>
> As a follow up on the patch on Linux: de4eceab578e
> ("smb3: allow dumping session and tcon id to improve stats analysis
> and debugging") [1]
>
> Add `gettconinfo` command to dump both the TCON Id and Session Id of
> a given SMB mount; to help with correlation in cases when multiple
> mounts are to the same share.
>
> Example run:
> ```
> ./smbinfo gettconinfo /mnt/smb_share
> TCON Id: 0x1
> Session Id: 0xa40000000001
> ```
>
> [1] https://github.com/torvalds/linux/commit/de4eceab578ead12a71e5b5588a5=
7e142bbe8ceb
>
> Cc: Pavel Shilovsky <pshilovsky@samba.org>
> Cc: Steve French <stfrench@microsoft.com>
> Signed-off-by: Anthony Nandaa <profnandaa@gmail.com>
> ---
>  smbinfo     | 29 +++++++++++++++++++++++++++++
>  smbinfo.rst |  2 ++
>  2 files changed, 31 insertions(+)
>
> diff --git a/smbinfo b/smbinfo
> index 73c5bb3..3467b0b 100755
> --- a/smbinfo
> +++ b/smbinfo
> @@ -35,6 +35,7 @@ CIFS_QUERY_INFO          =3D 0xc018cf07
>  CIFS_ENUMERATE_SNAPSHOTS =3D 0x800ccf06
>  CIFS_DUMP_KEY            =3D 0xc03acf08
>  CIFS_DUMP_FULL_KEY       =3D 0xc011cf0a
> +CIFS_GET_TCON_INFO       =3D 0x800ccf0c
>
>  # large enough input buffer length
>  INPUT_BUFFER_LENGTH =3D 16384
> @@ -289,6 +290,10 @@ def main():
>      sap.add_argument("file")
>      sap.set_defaults(func=3Dcmd_keys)
>
> +    sap =3D subp.add_parser("gettconinfo", help=3D"Prints TCON Id and Se=
ssion Id for a cifs file")
> +    sap.add_argument("file")
> +    sap.set_defaults(func=3Dcmd_gettconinfo)
> +
>      # parse arguments
>      args =3D ap.parse_args()
>
> @@ -876,5 +881,29 @@ def cmd_keys(args):
>          print("ServerIn  Key: %s"%bytes_to_hex(kd.server_in_key))
>          print("ServerOut key: %s"%bytes_to_hex(kd.server_out_key))
>
> +class SmbMntTconInfoStruct:
> +    def __init__(self):
> +        self.tid =3D 0
> +        self.session_id =3D 0
> +
> +    def ioctl(self, fd):
> +        buf =3D bytearray()
> +        buf.extend(struct.pack("=3DIQ", self.tid, self.session_id))
> +        fcntl.ioctl(fd, CIFS_GET_TCON_INFO, buf, True)
> +        (self.tid, self.session_id) =3D struct.unpack_from('=3DIQ', buf,=
 0)
> +
> +def cmd_gettconinfo(args):
> +    fd =3D os.open(args.file, os.O_RDONLY)
> +    tcon =3D SmbMntTconInfoStruct()
> +
> +    try:
> +        tcon.ioctl(fd)
> +    except Exception as e:
> +        print("syscall failed: %s"%e)
> +        return False
> +
> +    print("TCON Id: 0x%x"%tcon.tid)
> +    print("Session Id: 0x%x"%tcon.session_id)
> +
>  if __name__ =3D=3D '__main__':
>      main()
> diff --git a/smbinfo.rst b/smbinfo.rst
> index 1acf3c4..17270c5 100644
> --- a/smbinfo.rst
> +++ b/smbinfo.rst
> @@ -96,6 +96,8 @@ COMMAND
>  the SMB3 traffic of this mount can be decryped e.g. via wireshark
>  (requires root).
>
> +`gettconinfo`: Prints both the TCON Id and Session Id for a cifs file.
> +
>  *****
>  NOTES
>  *****
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
