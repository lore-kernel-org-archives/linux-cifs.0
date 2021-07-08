Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9FCCC07E96
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 23:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD94B61442
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 23:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhGHXRd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 19:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230425AbhGHXRd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 19:17:33 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF627C061574
        for <linux-cifs@vger.kernel.org>; Thu,  8 Jul 2021 16:14:49 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t3so10934704edc.7
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jul 2021 16:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PYqN/8kusvjwSE5DI+VAD9BltTdFP7k9Laod1MUzldM=;
        b=tP04ykIFzH1pY8bD+0o66irfkitjuXpWQncg4q/xx/lRUST2p/ZL/aejc85eSl1uBg
         WYVvGJpMGiINjDac3ndap5AtOICZ4aeSInwysMWNjSm1O7so0wDwFYs8FZdOt90HZX0T
         mzq6qki8bJcLSwHEgmmHoekXwlJjrfLHjKY6l9cE+qTtNCDkuaf5+V6hCFVcNpolaMrv
         h/WAIvryREmKpwCk4gZKM2kqGV+GdI5I2Qn06VDmgg6TUnYIx5Zacuj2nPBy5Via3VY9
         NoTNU+ICWmL5AMxt6JIVVFEDSuztbZrYx09rvZmJv6E10DVTVwVdAB8NXUXxY8gUIBS0
         UwWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PYqN/8kusvjwSE5DI+VAD9BltTdFP7k9Laod1MUzldM=;
        b=P2RM9cBmMTfydtD+FUSRhTbPBb65udvO51LUiXaUaqB8c/G/E6V7ZsbU4biLTyP8qh
         iHAOW064lub/uOBjqElGblTtWhKeeCWUTgACfw+djHSGg4hxmsfkEJGMwpR5xA+ebIhS
         vWVy//X4uLbbAMq25eonBDkLUYqEq5fLkxSdDAmKARDyAglcI0eCmKfCF8CaBOpxaYVt
         rnkSSWA/QSIKDxcZP8T7pbB3SeSZ+n2wejKHYM1Gu5zsLFEz4ApEF1NT4nSFN/vOjWxT
         F9/NXxJ9oDaNoYdtooBV7pwJIoyiQngLQWA8Du8oKnzokd/pSSmEYPvag0RO+eJXqFoL
         Q4QQ==
X-Gm-Message-State: AOAM532A5TD9lvhblsh82rnDivDr6HF1sW/tz2RfRUqVAlvFWFuxeJmv
        Va2fQWU1I+UY4hEu6gEGd2GV6eMwDfZBEU4xxg==
X-Google-Smtp-Source: ABdhPJwDJR2jv6qD7mMMdfE+XKnmoiNA952C7MVZ1JYgC4Wwqq8KBl1TYRehSvuNYV0RdrvpD26NCjo2w9xj/bGca5k=
X-Received: by 2002:a50:875d:: with SMTP id 29mr18786359edv.340.1625786088314;
 Thu, 08 Jul 2021 16:14:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210521152940.23072-1-aaptel@suse.com>
In-Reply-To: <20210521152940.23072-1-aaptel@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Thu, 8 Jul 2021 16:14:37 -0700
Message-ID: <CAKywueT80W0Q25HDb=cDR3JoVzanEPzrFzjwAqqqsf_6Sx9Yjg@mail.gmail.com>
Subject: Re: [PATCH cifs-utils] smbinfo: add support for new key dump ioctl
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 21 =D0=BC=D0=B0=D1=8F 2021 =D0=B3. =D0=B2 08:29, Aur=C3=A9lie=
n Aptel <aaptel@suse.com>:
>
> From: Aurelien Aptel <aaptel@suse.com>
>
> * try new one first, fall back on old one otherwise =3D> retrocompatible
> * use better cipher descriptions
>
> Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> ---
>  smbinfo | 79 +++++++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 63 insertions(+), 16 deletions(-)
>
> diff --git a/smbinfo b/smbinfo
> index b96fdbc..73c5bb3 100755
> --- a/smbinfo
> +++ b/smbinfo
> @@ -34,6 +34,7 @@ VERBOSE =3D False
>  CIFS_QUERY_INFO          =3D 0xc018cf07
>  CIFS_ENUMERATE_SNAPSHOTS =3D 0x800ccf06
>  CIFS_DUMP_KEY            =3D 0xc03acf08
> +CIFS_DUMP_FULL_KEY       =3D 0xc011cf0a
>
>  # large enough input buffer length
>  INPUT_BUFFER_LENGTH =3D 16384
> @@ -192,9 +193,11 @@ ACE_FLAGS =3D [
>  ]
>
>  CIPHER_TYPES =3D [
> -    (0x00, "SMB3.0 CCM encryption"),
> -    (0x01, "CCM encryption"),
> -    (0x02, "GCM encryption"),
> +    (0x00, "AES-128-CCM"),
> +    (0x01, "AES-128-CCM"),
> +    (0x02, "AES-128-GCM"),
> +    (0x03, "AES-256-CCM"),
> +    (0x04, "AES-256-GCM"),
>  ]
>
>  def main():
> @@ -799,35 +802,79 @@ class KeyDebugInfoStruct:
>      def __init__(self):
>          self.suid =3D bytearray()
>          self.cipher =3D 0
> -        self.auth_key =3D bytearray()
> +        self.session_key =3D bytearray()
>          self.enc_key =3D bytearray()
>          self.dec_key =3D bytearray()
>
>      def ioctl(self, fd):
>          buf =3D bytearray()
>          buf.extend(struct.pack("=3D 8s H 16s 16s 16s", self.suid, self.c=
ipher,
> -                               self.auth_key, self.enc_key, self.dec_key=
))
> +                               self.session_key, self.enc_key, self.dec_=
key))
>          fcntl.ioctl(fd, CIFS_DUMP_KEY, buf, True)
> -        (self.suid, self.cipher, self.auth_key,
> +        (self.suid, self.cipher, self.session_key,
>           self.enc_key, self.dec_key) =3D struct.unpack_from('=3D 8s H 16=
s 16s 16s', buf, 0)
>
> +class FullKeyDebugInfoStruct:
> +    def __init__(self):
> +        # lets pick something large to be future proof
> +        # 17 + 3*32 would be strict minimum as of linux 5.13
> +        self.in_size =3D 1024
> +        self.suid =3D bytearray()
> +        self.cipher =3D 0
> +        self.session_key_len =3D 0
> +        self.server_in_key_len =3D 0
> +        self.server_out_key_len =3D 0
> +
> +    def ioctl(self, fd):
> +        fmt =3D "=3D I 8s H B B B"
> +        size =3D struct.calcsize(fmt)
> +        buf =3D bytearray()
> +        buf.extend(struct.pack(fmt, self.in_size, self.suid, self.cipher=
,
> +                               self.session_key_len, self.server_in_key_=
len, self.server_out_key_len))
> +        buf.extend(bytearray(self.in_size-size))
> +        fcntl.ioctl(fd, CIFS_DUMP_FULL_KEY, buf, True)
> +        (self.in_size, self.suid, self.cipher,
> +         self.session_key_len, self.server_in_key_len,
> +         self.server_out_key_len) =3D struct.unpack_from(fmt, buf, 0)
> +
> +        end =3D size
> +        self.session_key =3D buf[end:end+self.session_key_len]
> +        end +=3D self.session_key_len
> +        self.server_in_key =3D buf[end:end+self.server_in_key_len]
> +        end +=3D self.server_in_key_len
> +        self.server_out_key =3D buf[end:end+self.server_out_key_len]
> +
>  def bytes_to_hex(buf):
>      return " ".join(["%02x"%x for x in buf])
>
>  def cmd_keys(args):
> -    kd =3D KeyDebugInfoStruct()
> +    fd =3D os.open(args.file, os.O_RDONLY)
> +    kd =3D FullKeyDebugInfoStruct()
> +
>      try:
> -        fd =3D os.open(args.file, os.O_RDONLY)
> +        # try new call first
>          kd.ioctl(fd)
>      except Exception as e:
> -        print("syscall failed: %s"%e)
> -        return False
> -
> -    print("Session Id: %s"%bytes_to_hex(kd.suid))
> -    print("Cipher: %s"%type_to_str(kd.cipher, CIPHER_TYPES, verbose=3DTr=
ue))
> -    print("Session Key: %s"%bytes_to_hex(kd.auth_key))
> -    print("Encryption key: %s"%bytes_to_hex(kd.enc_key))
> -    print("Decryption key: %s"%bytes_to_hex(kd.dec_key))
> +        # new failed, try old call
> +        kd =3D KeyDebugInfoStruct()
> +        try:
> +            kd.ioctl(fd)
> +        except Exception as e:
> +            # both new and old call failed
> +            print("syscall failed: %s"%e)
> +            return False
> +        print("Session Id: %s"%bytes_to_hex(kd.suid))
> +        print("Cipher: %s"%type_to_str(kd.cipher, CIPHER_TYPES, verbose=
=3DTrue))
> +        print("Session Key: %s"%bytes_to_hex(kd.session_key))
> +        print("Encryption key: %s"%bytes_to_hex(kd.enc_key))
> +        print("Decryption key: %s"%bytes_to_hex(kd.dec_key))
> +    else:
> +        # no exception, new call succeeded
> +        print("Session Id: %s"%bytes_to_hex(kd.suid))
> +        print("Cipher: %s"%type_to_str(kd.cipher, CIPHER_TYPES, verbose=
=3DTrue))
> +        print("Session Key: %s"%bytes_to_hex(kd.session_key))
> +        print("ServerIn  Key: %s"%bytes_to_hex(kd.server_in_key))
> +        print("ServerOut key: %s"%bytes_to_hex(kd.server_out_key))
>
>  if __name__ =3D=3D '__main__':
>      main()
> --
> 2.31.1
>

Merged. Thanks!
--
Best regards,
Pavel Shilovsky
