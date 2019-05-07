Return-Path: <SRS0=vQ6B=TH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BC7C004C9
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 22:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FE4A20825
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 22:45:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gi0y3for"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfEGWpg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 May 2019 18:45:36 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33995 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGWpf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 May 2019 18:45:35 -0400
Received: by mail-lf1-f65.google.com with SMTP id v18so10840712lfi.1
        for <linux-cifs@vger.kernel.org>; Tue, 07 May 2019 15:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ac6PNAlRAmrD+gkhJ/xFteS8495rQ2wmk2FKMAlCndM=;
        b=gi0y3for1w3x59paGzngnvgvJxikvWLBNq98hHhLTxUrFU9W/EuJV0tNUPSKtuquQ6
         AjgtUpLidnxFyP2raYJyLLO9QOkEc19jG0ajwi1+xA4DhyUhlmPnUW/ans6lCwlI//vC
         YQIyMMIwqxunYRe+jJ+yeRc+bJQfba5swJ7yDjNAaBlLJ7eiHo2IVBxeGnvhmU+XE18b
         CJJ8OY9QWIAHbOiXDgW8PWwrtO2vJ1al8kKMoX96K0mVdnlakZWXw83yKx9zAEQF2evq
         ydBst7nCVT7lCdOFqAl1gWHdK9HMyciOgoA/3rkfYtxM8yNwrmxQkdg6kDDB0yLSh40S
         xwUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ac6PNAlRAmrD+gkhJ/xFteS8495rQ2wmk2FKMAlCndM=;
        b=DXOYY9eEujHgsT0IAIFxjxGSZz6kr2cO9KFYOSuadz9nmDlRhZ5nYKNPVZDNhWtYB/
         SWjEh8YyZuruCSiHGorTTSXUGzv94tqLPqlsu/s/7S1lkC3SSqK/+1McoKhhPoldUZKM
         l66UPlUgaBtGoiY+cuX7tYs6LPcoMsCVOyjgOun6VIfXaE/tRumnoQDg0pt9Js6nlokj
         t/egakQjOuQlTZbWTO6s/KyHbkC5HmPGhkf4/l7I+W63rg3AASgghQE4d8wxwpOc2A1H
         GEThfxE4iA4GhliVw5mNX7WV9LqwaMdl0pmPfu8GjZjuepE6lX+rwkCb7/N5RIaFy7rn
         /GrQ==
X-Gm-Message-State: APjAAAW9J+LvknTiCfJg5v7Ub4r+iEKlnLc8L2hbRlr+CSExnGXgDFeD
        QIpZwhfVYAJVCMMHR3ldVyqlABwSeV2Bp87xxw==
X-Google-Smtp-Source: APXvYqxEYgXa3XYRfHV6cRj8yml2g/l5Nmikx4HBuVIE1iWtDyrLtTeGRabGWpckR+3n5g1ajM9O7jc+LRK/rwyLT4I=
X-Received: by 2002:a19:385e:: with SMTP id d30mr16009682lfj.119.1557269134044;
 Tue, 07 May 2019 15:45:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190411022307.26463-1-lsahlber@redhat.com> <20190411022307.26463-3-lsahlber@redhat.com>
 <CAKywueTAjbRsmUFpO=u_=wCmjC2xdoW2vO4QmARD=c4Yjyd3-Q@mail.gmail.com>
In-Reply-To: <CAKywueTAjbRsmUFpO=u_=wCmjC2xdoW2vO4QmARD=c4Yjyd3-Q@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 7 May 2019 15:45:22 -0700
Message-ID: <CAKywueS4hQqbt+TVBx41abKYf7PeZd+RO561L1OMKYWhxE-AbA@mail.gmail.com>
Subject: Re: [PATCH 2/2] smbinfo: Add SETCOMPRESSION support
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

=D1=81=D1=80, 17 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 14:47, Pavel Shilo=
vsky <piastryyy@gmail.com>:
>
> =D1=81=D1=80, 10 =D0=B0=D0=BF=D1=80. 2019 =D0=B3. =D0=B2 19:24, Ronnie Sa=
hlberg <lsahlber@redhat.com>:
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  smbinfo.c   | 28 ++++++++++++++++++++++++++++
> >  smbinfo.rst |  5 +++++
> >  2 files changed, 33 insertions(+)
> >
> > diff --git a/smbinfo.c b/smbinfo.c
> > index db569b2..b87cca4 100644
> > --- a/smbinfo.c
> > +++ b/smbinfo.c
> > @@ -89,6 +89,8 @@ usage(char *name)
> >                 "      Prints the objectid of the file and GUID of the =
underlying volume.\n"
> >                 "  getcompression:\n"
> >                 "      Prints the compression setting for the file.\n"
> > +               "  setcompression <0|1|2>:\n"
> > +               "      Sets the compression level for the file.\n"
> >                 "  list-snapshots:\n"
> >                 "      List the previous versions of the volume that ba=
cks this file.\n"
> >                 "  quota:\n"
> > @@ -289,6 +291,30 @@ getcompression(int f)
> >  }
> >
> >  static void
> > +setcompression(int f, uint16_t level)
> > +{
> > +       struct smb_query_info *qi;
> > +
> > +       qi =3D malloc(sizeof(struct smb_query_info) + 2);
> > +       memset(qi, 0, sizeof(qi) + 2);
> > +       qi->info_type =3D 0x9c040;
> > +       qi->file_info_class =3D 0;
> > +       qi->additional_information =3D 0;
> > +       qi->output_buffer_length =3D 2;
> > +       qi->flags =3D PASSTHRU_FSCTL;
> > +
> > +       level =3D htole16(level);
> > +       memcpy(&qi[1], &level, 2);
> > +
> > +       if (ioctl(f, CIFS_QUERY_INFO, qi) < 0) {
> > +               fprintf(stderr, "ioctl failed with %s\n", strerror(errn=
o));
> > +               exit(1);
> > +       }
> > +
> > +       free(qi);
> > +}
> > +
> > +static void
> >  print_fileaccessinfo(uint8_t *sd, int type)
> >  {
> >         uint32_t access_flags;
> > @@ -1166,6 +1192,8 @@ int main(int argc, char *argv[])
> >                 fsctlgetobjid(f);
> >         else if (!strcmp(argv[optind], "getcompression"))
> >                 getcompression(f);
> > +       else if (!strcmp(argv[optind], "setcompression"))
> > +               setcompression(f, strtol(argv[optind + 2], NULL, 10));
> >         else if (!strcmp(argv[optind], "list-snapshots"))
> >                 list_snapshots(f);
> >         else if (!strcmp(argv[optind], "quota"))
> > diff --git a/smbinfo.rst b/smbinfo.rst
> > index ca99b07..af97b7f 100644
> > --- a/smbinfo.rst
> > +++ b/smbinfo.rst
> > @@ -66,6 +66,11 @@ COMMAND
> >
> >  `getcompression`: Prints the compression setting for the file.
> >
> > +`setcompression <0|1|2>`: Sets the compression setting for the file.
> > +- 0 No compression
> > +- 1 Default compression
> > +- 2 LZNT1
>
> 0, 1 and 2 don't look obvious, how about "no", "default", "lznt1"?
> --
> Best regards,
> Pavel Shilovsky

I tried it and I think the syntax is strange:

smbinfo setcompression /mnt/test/file 1

How about this:

smbinfo setcompression [-c <0|1|2>] <filename> ?

-c would be 1 by default, so smbinfo setcompression <filename> will
set a default compression. Also as I mentioned before specifying "no",
"default" and "lznt1" looks better to me but I am ok with integers
too.

--
Best regards,
Pavel Shilovsky
