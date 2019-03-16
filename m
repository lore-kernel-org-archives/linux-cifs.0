Return-Path: <SRS0=lfdc=RT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59D8AC43381
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 19:47:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D7E1218AC
	for <linux-cifs@archiver.kernel.org>; Sat, 16 Mar 2019 19:47:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WA+i/DsB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbfCPTrM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 16 Mar 2019 15:47:12 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:38235 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfCPTrM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 16 Mar 2019 15:47:12 -0400
Received: by mail-lf1-f66.google.com with SMTP id a6so6736637lfl.5
        for <linux-cifs@vger.kernel.org>; Sat, 16 Mar 2019 12:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=90OzPBlzH08RCNCjJMOPAgY83FtEWisDZs5LiS27LB4=;
        b=WA+i/DsBw1hdciaQmieTewST5ggnV0PYCB/s2BaAmZCkgcpOGHdru7Kdyul5ZOYwZA
         8kJui9ERHJhg6kJZQQ00AjmSjldBXlnA5E2Av2UMTB2wblt6qSAJ3vl6V8E+nQmSCzti
         dwszvdsCmLs8hUc0A8E+1I1YOOWU+0oJTgsLgAzmg+zJi7tj+A/EN0ryZF+YnZmnheTh
         /v9fuVSjUuyMdKKYE9ybmnL6cNE0sfeQahOiNy56aBZspzvgBVlT7gxefpZhqormoSVG
         NA5aw36aA83frs3m5US1ZtvXlJBY80V2mvO8wphf1BW8DACnfJcu4CzCuprWLM+qu5Er
         9YqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=90OzPBlzH08RCNCjJMOPAgY83FtEWisDZs5LiS27LB4=;
        b=poajkU7U6FZTJuRR/D0Jb5OKJa0qzs0QPu0G97iRw5FGX1F07SvOEAGsaavph6jjHk
         5Db3xnz+/7hqjRwNbqErdofSXh/VWrV8GlbdLYbTfHFdpFIC0qf1PF+NENIFx9A93Lm6
         OPe34LJZ7NCpqQSkqcoqPdE8QhWX/4Bve+mIVgofcKHKKmtCvbFVHjdLYXK7LqX8Sdbt
         fugKi8+L5TCh8O5gIxhb/Xi1Nfm77kWiAK1GDV37J1Z8Qmy0MiGN1AD/5/nQ4qYq2SET
         or0PQs6jtVBJ4cOuRweZj8G4MAfL6dieP0DdtmJuqH5VuHe86ZnIbSFsBwxiXbq5h6V1
         ROTQ==
X-Gm-Message-State: APjAAAWfAeyFFZnPgMauL65ONH7BIWohXlumimi02AftyTN+jkzbe5QY
        tHyp3houKg5goHQFVtyxlhWOmx2Uz4WNFz9sdA==
X-Google-Smtp-Source: APXvYqz8tAOO4x4kepiPOqLqQpLe6JbvLBzXQJs7+joDe8xSBEmWHgY6TtLJ0Ajo0YHJdnp9rIg+2+9ETfHpq5EeXns=
X-Received: by 2002:a19:960c:: with SMTP id y12mr5403016lfd.159.1552765630343;
 Sat, 16 Mar 2019 12:47:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190315062215.29499-1-lsahlber@redhat.com> <20190315062215.29499-2-lsahlber@redhat.com>
In-Reply-To: <20190315062215.29499-2-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Sat, 16 Mar 2019 12:46:58 -0700
Message-ID: <CAKywueT4JzwLW3uAvYAM4trQPJb8UFfdXy=Aa1RmcD8bT=cAPQ@mail.gmail.com>
Subject: Re: [PATCH] smbinfo: add fsctl-getobjid support
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 14 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 23:22, Ronnie Sahl=
berg <lsahlber@redhat.com>:
>
> This will print the ObjectID buffer for the object.
> This is an example on how to fetch FSCTL data for an object using
> the passthrough API.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  smbinfo.c   | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  smbinfo.rst |  2 ++
>  2 files changed, 75 insertions(+)
>
> diff --git a/smbinfo.c b/smbinfo.c
> index 6b63f9d..215842c 100644
> --- a/smbinfo.c
> +++ b/smbinfo.c
> @@ -39,6 +39,11 @@
>  #include <inttypes.h>
>
>  #define CIFS_IOCTL_MAGIC 0xCF
> +
> +/* query_info flags */
> +#define PASSTHRU_QUERY_INFO     0x00000000
> +#define PASSTHRU_FSCTL          0x00000001
> +
>  struct smb_query_info {
>          uint32_t   info_type;
>          uint32_t   file_info_class;
> @@ -170,6 +175,72 @@ print_bits(uint32_t mask, struct bit_string *bs)
>  }
>
>  static void
> +print_guid(uint8_t *sd)
> +{
> +       uint32_t u32;
> +       uint16_t u16;
> +       int i;
> +
> +       memcpy(&u32, &sd[0], 4);
> +       printf("%08x-", le32toh(u32));
> +
> +       memcpy(&u16, &sd[4], 2);
> +       printf("%04x-", le16toh(u16));
> +
> +       memcpy(&u16, &sd[6], 2);
> +       printf("%04x-", le16toh(u16));
> +
> +       printf("%02x%02x-", sd[8], sd[9]);
> +       for (i =3D 0; i < 6; i++)
> +               printf("%02x", sd[10 + i]);
> +}
> +
> +static void
> +print_objidbuf(uint8_t *sd)
> +{
> +       printf("Object-ID: ");
> +       print_guid(&sd[0]);
> +       printf("\n");
> +
> +       printf("Birth-Volume-ID: ");
> +       print_guid(&sd[16]);
> +       printf("\n");
> +
> +       printf("Birth-Object-ID: ");
> +       print_guid(&sd[32]);
> +       printf("\n");
> +
> +       printf("Domain-ID: ");
> +       print_guid(&sd[48]);
> +       printf("\n");
> +}
> +
> +static void
> +fsctlgetobjid(int f)
> +{
> +       struct smb_query_info *qi;
> +       struct stat st;
> +
> +       fstat(f, &st);
> +
> +       qi =3D malloc(sizeof(struct smb_query_info) + 64);
> +       memset(qi, 0, sizeof(qi) + 64);
> +       qi->info_type =3D 0x9009c;
> +       qi->file_info_class =3D 0;
> +       qi->additional_information =3D 0;
> +       qi->input_buffer_length =3D 64;
> +       qi->flags =3D PASSTHRU_FSCTL;
> +
> +       if (ioctl(f, CIFS_QUERY_INFO, qi) < 0) {
> +               fprintf(stderr, "ioctl failed with %s\n", strerror(errno)=
);
> +               exit(1);
> +       }
> +       print_objidbuf((uint8_t *)(&qi[1]));
> +
> +       free(qi);
> +}
> +
> +static void
>  print_fileaccessinfo(uint8_t *sd, int type)
>  {
>          uint32_t access_flags;
> @@ -951,6 +1022,8 @@ int main(int argc, char *argv[])
>                  secdesc(f);
>          else if (!strcmp(argv[optind], "quota"))
>                  quota(f);
> +        else if (!strcmp(argv[1], "fsctl-getobjid"))
> +                fsctlgetobjid(f);
>          else {
>                  fprintf(stderr, "Unknown command %s\n", argv[optind]);
>                  exit(1);
> diff --git a/smbinfo.rst b/smbinfo.rst
> index 9bfd313..fd7f0ff 100644
> --- a/smbinfo.rst
> +++ b/smbinfo.rst
> @@ -62,6 +62,8 @@ COMMAND
>
>  `filestandardinfo`: Prints the FileStandardInformation class
>
> +`fsctl-getobjid`: Prints the ObjectID
> +
>  `quota`: Print the quota for the volume in the form
>  - SID Length
>  - Change Time
> --
> 2.13.6
>

Fixed spaces to tabs and applied. Thanks.

--
Best regards,
Pavel Shilovsky
