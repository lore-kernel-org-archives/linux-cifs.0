Return-Path: <SRS0=BG3M=RM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FAF1C43381
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EB15206DF
	for <linux-cifs@archiver.kernel.org>; Sat,  9 Mar 2019 00:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ijXokGhp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfCIAiV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Mar 2019 19:38:21 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44410 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbfCIAiV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Mar 2019 19:38:21 -0500
Received: by mail-lf1-f65.google.com with SMTP id u9so11364768lfe.11
        for <linux-cifs@vger.kernel.org>; Fri, 08 Mar 2019 16:38:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MBFOSpih2javdmr9HuDYJrUpgJpNykI0dXhGWUzdLa8=;
        b=ijXokGhpAJe3mY4qRcRmvLIIiGCxMLRaStafchwsDThKTcdelueALZdYfs0NLI4Vz+
         1P6sK8qqVwRfX3CvSH06taumHLq2kAk1Jr6GeoS98yfcsAkNJY9kBuTX3Eb9j74PcGAt
         0lFebB6fG8nYzMMGsHvqhtkWjCjHY8YR1PgrvddEAG5Razb0keFXhbBdRrK8QsLXMnDc
         RIyDHL2RwsNPFWBjap4xVBT3HU6vaV0FgPzcHWagD/EoDsDg4K/YnXRzbyrDajUV5h3r
         e26B2HH7txwWJnaVcGjrutOn4mOgkVsfe9C6LdLLmbZBUhDXhiDhmicvirGESpmGqvU+
         wABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MBFOSpih2javdmr9HuDYJrUpgJpNykI0dXhGWUzdLa8=;
        b=en4snW/GqFX4acGq/KyhaVCxnpy+0/ThqiDYVg5a2Bd2VJ4KuY3rFAt2wWngtnQk/2
         u1FKzksscqBoxM1Pon627z35Nq+ktoqKny9BfvkBXzQakK6LrNDqr9aF3FgUm54vx7yb
         qTQgnDDTfAXmXfm0GLr3Z53mYteJrAwrfBqb8tWP9Hx/4gvi645+PByH6F9GMZSd7Ofm
         DlKA6JBAba1HeoGSEg5bxRJosRebaKfttBIGnrslbsdK700M1Sskeb4oBJbtfCcOIVJj
         zQ2SYNa9CHRAmGV92drGRVwDZY/C47Fs6DlV/MtdxwJBGYy7uYOuhLLvDEXvBQxYgS3r
         1NuQ==
X-Gm-Message-State: APjAAAVF7ewYrcxUdgmzkhygxjB4/TKVVj5uHRv6AzEEvl+c5yYvpNnO
        Zsva4V/axKZwl3+rm9yppYuCQpi1i0foJaCrgny07XI=
X-Google-Smtp-Source: APXvYqy3sTzbUQEvEpXvmxeo7QaTrd/Dx1X4cn9SIkvZ45rs9gDYOnb2O+T1uC2He9TLeIOENDDK+6DxlP/wYv4aM/g=
X-Received: by 2002:ac2:4192:: with SMTP id z18mr11333327lfh.39.1552091898483;
 Fri, 08 Mar 2019 16:38:18 -0800 (PST)
MIME-Version: 1.0
References: <20190301020558.16091-1-lsahlber@redhat.com>
In-Reply-To: <20190301020558.16091-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 8 Mar 2019 16:38:07 -0800
Message-ID: <CAKywueSBhdzr9X1QUXvO8WeoPxZTW_N2+_Z8w-ZkrCZxXHmg=A@mail.gmail.com>
Subject: Re: [PATCH] smbinfo: decode the ACEs
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

=D1=87=D1=82, 28 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 18:12, Ronni=
e Sahlberg <lsahlber@redhat.com>:
>
> Decode the most common ACE types and provide a [-V]erbose option
> to show the individual mask bits by name.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  smbinfo.c   | 197 ++++++++++++++++++++++++++++++++++++++++++++++++++----=
------
>  smbinfo.rst |   5 +-
>  2 files changed, 168 insertions(+), 34 deletions(-)
>
> diff --git a/smbinfo.c b/smbinfo.c
> index 02910c6..6b63f9d 100644
> --- a/smbinfo.c
> +++ b/smbinfo.c
> @@ -52,10 +52,13 @@ struct smb_query_info {
>  #define CIFS_QUERY_INFO _IOWR(CIFS_IOCTL_MAGIC, 7, struct smb_query_info=
)
>  #define INPUT_BUFFER_LENGTH 16384
>
> +int verbose;
> +
>  static void
>  usage(char *name)
>  {
> -        fprintf(stderr, "Usage: %s <command> <file>\n"
> +        fprintf(stderr, "Usage: %s [-V] <command> <file>\n"
> +               "-V for verbose output\n"
>                  "Commands are\n"
>                  "  fileaccessinfo:\n"
>                  "      Prints FileAccessInfo for a cifs file.\n"
> @@ -148,11 +151,22 @@ struct bit_string file_access_mask[] =3D {
>  static void
>  print_bits(uint32_t mask, struct bit_string *bs)
>  {
> +        int first =3D 1;
> +
> +       if (!verbose) {
> +               return;
> +       }
> +
>          while (bs->string) {
> -                if (mask & bs->bit)
> -                    printf("%s ", bs->string);
> +               if (mask & bs->bit) {
> +                       printf("%s%s", first?"":",", bs->string);
> +                       first =3D 0;
> +               }
>                  bs++;
>          }
> +       if (!first) {
> +               printf(" ");
> +       }
>  }
>
>  static void
> @@ -591,17 +605,106 @@ print_sid(unsigned char *sd)
>          for (i =3D 0; i < sd[1]; i++) {
>                  memcpy(&subauth, &sd[8 + 4 * i], 4);
>                  subauth =3D le32toh(subauth);
> -                printf("-%d", subauth);
> +                printf("-%u", subauth);
>          }
>  }
>
>  static void
> -print_acl(unsigned char *sd)
> +print_ace_type(uint8_t t)
> +{
> +        switch(t) {
> +       case 0x00: printf("ALLOWED"); break;
> +       case 0x01: printf("DENIED"); break;
> +       case 0x02: printf("AUDIT"); break;
> +       case 0x03: printf("ALARM"); break;
> +       case 0x04: printf("ALLOWED_COMPOUND"); break;
> +       case 0x05: printf("ALLOWED_OBJECT"); break;
> +       case 0x06: printf("DENIED_OBJECT"); break;
> +       case 0x07: printf("AUDIT_OBJECT"); break;
> +       case 0x08: printf("ALARM_OBJECT"); break;
> +       case 0x09: printf("ALLOWED_CALLBACK"); break;
> +       case 0x0a: printf("DENIED_CALLBACK"); break;
> +       case 0x0b: printf("ALLOWED_CALLBACK_OBJECT"); break;
> +       case 0x0c: printf("DENIED_CALLBACK_OBJECT"); break;
> +       case 0x0d: printf("AUDIT_CALLBACK"); break;
> +       case 0x0e: printf("ALARM_CALLBACK"); break;
> +       case 0x0f: printf("AUDIT_CALLBACK_OBJECT"); break;
> +       case 0x10: printf("ALARM_CALLBACK_OBJECT"); break;
> +       case 0x11: printf("MANDATORY_LABEL"); break;
> +       case 0x12: printf("RESOURCE_ATTRIBUTE"); break;
> +       case 0x13: printf("SCOPED_POLICY_ID"); break;
> +       default: printf("<UNKNOWN>");
> +       }
> +       printf(" ");
> +}
> +
> +struct bit_string ace_flags_mask[] =3D {
> +        { 0x80, "FAILED_ACCESS" },
> +        { 0x40, "SUCCESSFUL_ACCESS" },
> +        { 0x10, "INHERITED" },
> +        { 0x08, "INHERIT_ONLY" },
> +        { 0x04, "NO_PROPAGATE_INHERIT" },
> +        { 0x02, "CONTAINER_INHERIT" },
> +        { 0x01, "OBJECT_INHERIT" },
> +        { 0, NULL }
> +};
> +
> +static void
> +print_mask_sid_ace(unsigned char *sd, int type)
> +{
> +        uint32_t u32;
> +
> +        memcpy(&u32, &sd[0], 4);
> +       printf("Mask:0x%08x ", le32toh(u32));
> +       if (type =3D=3D S_IFDIR) {
> +               print_bits(le32toh(u32), directory_access_mask);
> +        } else {
> +               print_bits(le32toh(u32), file_access_mask);
> +       }
> +       printf("SID:");
> +       print_sid(&sd[4]);
> +       printf("\n");
> +}
> +
> +static int
> +print_ace(unsigned char *sd, int type)
> +{
> +        uint16_t size;
> +       int i;
> +
> +       printf("Type:0x%02x ", sd[0]);
> +       if (verbose) {
> +               print_ace_type(sd[0]);
> +       }
> +
> +       printf("Flags:0x%02x ", sd[1]);
> +       print_bits(sd[1], ace_flags_mask);
> +
> +       memcpy(&size, &sd[2], 2);
> +       size =3D le16toh(size);
> +
> +       switch (sd[0]) {
> +       case 0x00:
> +       case 0x01:
> +       case 0x02:
> +               print_mask_sid_ace(&sd[4], type);
> +               break;
> +       default:
> +               for (i =3D 0; i < size; i++)
> +                       printf("%02x", sd[4 + i]);
> +       }
> +
> +       printf("\n");
> +       return size;
> +}
> +
> +static void
> +print_acl(unsigned char *sd, int type)
>  {
> -        int i, j, off;
> -        uint16_t count, size;
> +        int i, off;
> +        uint16_t count;
>
> -        if (sd[0] !=3D 2) {
> +        if ((sd[0] !=3D 2) && (sd[0] !=3D 4)) {
>                  fprintf(stderr, "Unknown ACL revision\n");
>                  return;
>          }
> @@ -610,22 +713,43 @@ print_acl(unsigned char *sd)
>          count =3D le16toh(count);
>          off =3D 8;
>          for (i =3D 0; i < count; i++) {
> -                printf("Type:%02x Flags:%02x ", sd[off], sd[off + 1]);
> -                memcpy(&size, &sd[off + 2], 2);
> -                size =3D le16toh(size);
> +               off +=3D print_ace(&sd[off], type);
> +        }
> +}
>
> -                for (j =3D 0; j < size; j++)
> -                        printf("%02x", sd[off + 4 + j]);
> +struct bit_string control_bits_mask[] =3D {
> +        { 0x8000, "SR" },
> +        { 0x4000, "RM" },
> +        { 0x2000, "PS" },
> +        { 0x1000, "PD" },
> +        { 0x0800, "SI" },
> +        { 0x0400, "DI" },
> +        { 0x0200, "SC" },
> +        { 0x0100, "DC" },
> +        { 0x0080, "DT" },
> +        { 0x0040, "SS" },
> +        { 0x0020, "SD" },
> +        { 0x0010, "SP" },
> +        { 0x0008, "DD" },
> +        { 0x0004, "DP" },
> +        { 0x0002, "GD" },
> +        { 0x0001, "OD" },
> +        { 0, NULL }
> +};
>
> -                off +=3D size;
> -                printf("\n");
> -        }
> +static void
> +print_control(uint16_t c)
> +{
> +       printf("Control: 0x%04x ", c);
> +       print_bits(c, control_bits_mask);
> +       printf("\n");
>  }
>
>  static void
> -print_sd(uint8_t *sd)
> +print_sd(uint8_t *sd, int type)
>  {
>          int offset_owner, offset_group, offset_dacl;
> +       uint16_t u16;
>
>          printf("Revision:%d\n", sd[0]);
>          if (sd[0] !=3D 1) {
> @@ -633,7 +757,8 @@ print_sd(uint8_t *sd)
>                  exit(1);
>          }
>
> -        printf("Control: %02x%02x\n", sd[2], sd[3]);
> +        memcpy(&u16, &sd[2], 2);
> +        print_control(le16toh(u16));
>
>          memcpy(&offset_owner, &sd[4], 4);
>          offset_owner =3D le32toh(offset_owner);
> @@ -654,7 +779,7 @@ print_sd(uint8_t *sd)
>          }
>          if (offset_dacl) {
>                  printf("DACL:\n");
> -                print_acl(&sd[offset_dacl]);
> +                print_acl(&sd[offset_dacl], type);
>          }
>  }
>
> @@ -662,6 +787,9 @@ static void
>  secdesc(int f)
>  {
>          struct smb_query_info *qi;
> +        struct stat st;
> +
> +        fstat(f, &st);
>
>          qi =3D malloc(sizeof(struct smb_query_info) + INPUT_BUFFER_LENGT=
H);
>          memset(qi, 0, sizeof(qi) + INPUT_BUFFER_LENGTH);
> @@ -675,7 +803,7 @@ secdesc(int f)
>                  exit(1);
>          }
>
> -        print_sd((uint8_t *)(&qi[1]));
> +        print_sd((uint8_t *)(&qi[1]), st.st_mode & S_IFMT);
>          free(qi);
>  }
>
> @@ -777,11 +905,14 @@ int main(int argc, char *argv[])
>          int c;
>          int f;
>
> -        while ((c =3D getopt_long(argc, argv, "v", NULL, NULL)) !=3D -1)=
 {
> +        while ((c =3D getopt_long(argc, argv, "vV", NULL, NULL)) !=3D -1=
) {
>                  switch (c) {
>                  case 'v':
>                          printf("smbinfo version %s\n", VERSION);
>                          return 0;
> +                case 'V':
> +                       verbose =3D 1;
> +                       break;
>                  default:
>                          usage(argv[0]);
>                  }
> @@ -796,29 +927,29 @@ int main(int argc, char *argv[])
>          }
>
>
> -        if (!strcmp(argv[1], "fileaccessinfo"))
> +        if (!strcmp(argv[optind], "fileaccessinfo"))
>                  fileaccessinfo(f);
> -        else if (!strcmp(argv[1], "filealigninfo"))
> +        else if (!strcmp(argv[optind], "filealigninfo"))
>                  filealigninfo(f);
> -        else if (!strcmp(argv[1], "fileallinfo"))
> +        else if (!strcmp(argv[optind], "fileallinfo"))
>                  fileallinfo(f);
> -        else if (!strcmp(argv[1], "filebasicinfo"))
> +        else if (!strcmp(argv[optind], "filebasicinfo"))
>                  filebasicinfo(f);
> -        else if (!strcmp(argv[1], "fileeainfo"))
> +        else if (!strcmp(argv[optind], "fileeainfo"))
>                  fileeainfo(f);
> -        else if (!strcmp(argv[1], "filefsfullsizeinfo"))
> +        else if (!strcmp(argv[optind], "filefsfullsizeinfo"))
>                  filefsfullsizeinfo(f);
> -        else if (!strcmp(argv[1], "fileinternalinfo"))
> +        else if (!strcmp(argv[optind], "fileinternalinfo"))
>                  fileinternalinfo(f);
> -        else if (!strcmp(argv[1], "filemodeinfo"))
> +        else if (!strcmp(argv[optind], "filemodeinfo"))
>                  filemodeinfo(f);
> -        else if (!strcmp(argv[1], "filepositioninfo"))
> +        else if (!strcmp(argv[optind], "filepositioninfo"))
>                  filepositioninfo(f);
> -        else if (!strcmp(argv[1], "filestandardinfo"))
> +        else if (!strcmp(argv[optind], "filestandardinfo"))
>                  filestandardinfo(f);
> -        else if (!strcmp(argv[1], "secdesc"))
> +        else if (!strcmp(argv[optind], "secdesc"))
>                  secdesc(f);
> -        else if (!strcmp(argv[1], "quota"))
> +        else if (!strcmp(argv[optind], "quota"))
>                  quota(f);
>          else {
>                  fprintf(stderr, "Unknown command %s\n", argv[optind]);
> diff --git a/smbinfo.rst b/smbinfo.rst
> index 5222a71..9bfd313 100644
> --- a/smbinfo.rst
> +++ b/smbinfo.rst
> @@ -11,7 +11,7 @@ Userspace helper to display SMB-specific file informati=
on for the Linux SMB clie
>  SYNOPSIS
>  ********
>
> -  smbinfo [-v] {command} {file system object}
> +  smbinfo [-v] [-V] {command} {file system object}
>
>  ***********
>  DESCRIPTION
> @@ -35,6 +35,9 @@ OPTIONS
>  -v
>    Print version number and exit.
>
> +-V
> +  Verbose output.
> +
>  *******
>  COMMAND
>  *******
> --
> 2.15.1
>

merged, thanks.
--
Best regards,
Pavel Shilovsky
