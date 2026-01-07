Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02137342534
	for <linux-cifs@vger.kernel.org>; Wed,  7 Jan 2026 19:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767814977; cv=none; b=NmUhKX23K5D5wDDaOrGbp8aeKW6u4zv7VJRJOlGoEABJoXIyH3fuo3M9GhUQ6ITULyYsYawjT+Z/3Mr982wE9YrXBeDIGyiU/YHXXYp83aKX3DqKWYKmEnR3jw9lSqCr7L7T6HtYYO8+ozTDi8qvZYD7cGrMHroxk1U50AnVA04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767814977; c=relaxed/simple;
	bh=runpX9tcVYZIsr76PAzd7KJlhGlRdl59J7dFu7Homt8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TV/7Qg6GhmIIx+rEoIGdiYn5AnGEbrtw/Mwh1SVgtFfKRROypIXwxiSAKbi5PJO2DPR8eOvTGhZ9LKFGsjD2Tk1nqcQQ74LSPxLOt7WB1MMg68kMhoiMznGBqU3MmerXoHEP6TbHJv5kkk2n7euGij64lgWcQId/kCwOKlZ8Uro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f5HUAqor; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f5HUAqor"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4f1b1948ffaso15534821cf.2
        for <linux-cifs@vger.kernel.org>; Wed, 07 Jan 2026 11:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767814966; x=1768419766; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RrJstrMrqTyof5Map5IaBsio4+p269zZO3fxKflWu7I=;
        b=f5HUAqor8WXH35KKJS6O7uUfWZo0TMSUHCC/MxA2gmowoa2m9rRSgKpNqHQ0jHLFmY
         4FIHc1m0n01OUuXklS8kP6h17xkThqtdp5i1gQV/ZzJA99N4SpkSs5jrLZlf9+eGWgOC
         mFaGzOy8Ob15LAnhXH+9qKwAItCcupYftyLQ+PGNCAJZrbiT7WeIOy36UFdHDS//+wcf
         xgHSYj92wOGLVv/r662vqx2cFWHCup/BI8KdWVmhwize7pLyrLH7Med9CCxEuuJAwE7D
         fx0yW8xct768uBXZqwetZTHwjA94IZnnyGPs0YR0w1wNhywJUUtDHniqZIRTF30e4UiB
         IXiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767814966; x=1768419766;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RrJstrMrqTyof5Map5IaBsio4+p269zZO3fxKflWu7I=;
        b=gNhJZhR77GbSy3zDwnwSbbK+7hAPODqFnOoFTbXh6poYBskSMgf0RaS9BYZnjpTZqQ
         QALCViyv312uiqEsCJQ09L0jQ967KpIqLxY2EMtXRPvcQz58wj9Wgg8uMXLf1Yc2E/e2
         q1aRrc3dkKKUgKvvpn4yLXM69LVtCv+0ofPx1ICRqTV4X/QuwhI7bGdeA8YwmXg0IXBI
         7SYohavjeWL268kzDm///rTTrXUX1Dx4azV6XsYMUgQ8dZKfwME9ONboKqbvPrZwEeyW
         Y2B6cO6Gw1dEEq6LcGzdEnCyrfpqAGKvsxpmY5Dmkiyc5XFlImfi6YwEy8OPcXP1FFXM
         kwLQ==
X-Gm-Message-State: AOJu0Yysn2OFE6xuY0CvJe9bJQl4MSG4ktVDEB2V1gvDlHl3B8rnaa80
	kezgZOPC2fwh59Iq1nEUrJ1cpBhRq65H2gDh6sA7NwiOx+ZjJsmkP8Jrq5vTRSvnsrrAS5DZKLa
	TNeTk+QbqF9ytEcbflO6sNXGWS82EcjSySg==
X-Gm-Gg: AY/fxX7VnO/kFiqWfIxbrt5mfIP1mcskAEMQ6EL9Ca11mSEtMcIIRU3YvHkVTEmyIIG
	BnqL0tCTCoaEf+4kp+goSrEDyJEbtxLxYTEhNUYrL5pRF+IleF7iW4V+LOQoK6ArEFNQquZMGL6
	YuPjcmpVd2h22tyuBiO2p1D5IuV3tx6Cc1lVDJyEwobivlbZ67PnXYDHAhbaRfeNIAAGwVxTm3v
	K2d7tMqfcjB1MDQF1hL24Bv0JMfDPjl6rQozhZygQ7ZH0OXpCw1Mx4x9IjjZd8qlfOFh9VkqI13
	ZrHq9J8Txe3OM42sr05Rb2Aiz9ftiVeBXy4HMHfk3MJq63MljA9G0iO5cBuUE7ApkKtMyLor8rG
	mYWeHilQDZaNMojtgHO6VwiLAa1og5DdqVUmB+62pdBI4yIoSYElPrgs8hwHPVQTn9ceSTXCxpj
	1Pv2xghpcrqw==
X-Google-Smtp-Source: AGHT+IFG1CZCa9tjwyqnbeHdgMh1ksapd1SxPMnNo9v8X/+IXDRYNllJ0L6yORl8nFDhKQTHLS/ppaf7LEHlHyEOBAQ=
X-Received: by 2002:a05:622a:13d4:b0:4ee:2984:7d95 with SMTP id
 d75a77b69052e-4ffb48bb23cmr53833691cf.13.1767814966156; Wed, 07 Jan 2026
 11:42:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107043109.1456095-1-chenxiaosong.chenxiaosong@linux.dev> <20260107043109.1456095-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20260107043109.1456095-2-chenxiaosong.chenxiaosong@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Wed, 7 Jan 2026 13:42:34 -0600
X-Gm-Features: AQt7F2rTzFZ0re9THqHEcrtcQxAiCgF1cs6Xyk4eyEkdw-30vEMjm5PaXDgKaig
Message-ID: <CAH2r5mtb65CsxQ_XnJGDWmmgERxHAMNNA31rdG4b8c5ibdEEBg@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] smbinfo: add notify subcommand
To: chenxiaosong.chenxiaosong@linux.dev
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

done - added to cifs-utils for-next, pending any additional review
comments and/or testing

On Tue, Jan 6, 2026 at 10:32=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Add `notify` subcommand to query a directory for change notifications.
>
> Example:
>
>   ./smbinfo notify /mnt/dir
>   # Then create a new file `/server/export/dir/file` on SMB server
>   Notify completed, returned data_len is 20
>   00000000:  00 00 00 00 01 00 00 00  08 00 00 00 66 00 69 00  ..........=
..f.i.
>   00000010:  6c 00 65 00                                       l.e.
>   # Call `ioctl()` again
>
> Press `Ctrl+C` to exit `smbinfo`.
>
> Link: https://lore.kernel.org/linux-cifs/CAH2r5msHiZWzP5hdtPgb+wV3DL3J31R=
tgQRLQeuhCa_ULt3PfA@mail.gmail.com/
> Suggested-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  smbinfo     | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  smbinfo.rst |  2 ++
>  2 files changed, 80 insertions(+)
>
> diff --git a/smbinfo b/smbinfo
> index 2e9e42d..57e8a0a 100755
> --- a/smbinfo
> +++ b/smbinfo
> @@ -27,6 +27,7 @@ import struct
>  import stat
>  import datetime
>  import calendar
> +import threading
>
>  VERBOSE =3D False
>
> @@ -36,6 +37,7 @@ CIFS_ENUMERATE_SNAPSHOTS =3D 0x800ccf06
>  CIFS_DUMP_KEY            =3D 0xc03acf08
>  CIFS_DUMP_FULL_KEY       =3D 0xc011cf0a
>  CIFS_GET_TCON_INFO       =3D 0x800ccf0c
> +CIFS_IOC_NOTIFY_INFO     =3D 0xc009cf0b
>
>  # large enough input buffer length
>  INPUT_BUFFER_LENGTH =3D 16384
> @@ -294,6 +296,10 @@ def main():
>      sap.add_argument("file")
>      sap.set_defaults(func=3Dcmd_gettconinfo)
>
> +    sap =3D subp.add_parser("notify", help=3D"Query a directory for chan=
ge notifications")
> +    sap.add_argument("file")
> +    sap.set_defaults(func=3Dcmd_notify)
> +
>      # parse arguments
>      args =3D ap.parse_args()
>
> @@ -905,5 +911,77 @@ def cmd_gettconinfo(args):
>      print("TCON Id: 0x%x"%tcon.tid)
>      print("Session Id: 0x%x"%tcon.session_id)
>
> +def cmd_notify(args):
> +    try:
> +        fd =3D os.open(args.file, os.O_RDONLY)
> +    except Exception as e:
> +        print("syscall failed: %s"%e)
> +        return False
> +
> +    thread =3D threading.Thread(target=3Dnotify_thread, args=3D(fd,))
> +    thread.start()
> +
> +    try:
> +        thread.join()
> +    except KeyboardInterrupt:
> +        pass
> +    finally:
> +        os.close(fd)
> +        return False
> +
> +def notify_thread(fd):
> +    fmt =3D "<IBI"
> +    # See `struct smb3_notify_info` in linux kernel fs/smb/client/cifs_i=
octl.h
> +    completion_filter =3D 0xFFF
> +    watch_tree =3D True
> +    data_len =3D 1000
> +
> +    while True:
> +        buf =3D bytearray(struct.pack(fmt, completion_filter, watch_tree=
, data_len))
> +        buf.extend(bytearray(data_len))
> +
> +        try:
> +            fcntl.ioctl(fd, CIFS_IOC_NOTIFY_INFO, buf, True)
> +        except Exception as e:
> +            print("syscall failed: %s"%e)
> +            return False
> +
> +        _, _, data_len_returned =3D struct.unpack_from(fmt, buf, 0)
> +        print("Notify completed, returned data_len is", data_len_returne=
d)
> +        notify_data, =3D struct.unpack_from(f'{data_len_returned}s', buf=
, struct.calcsize(fmt))
> +        print_notify(notify_data)
> +
> +def print_notify(notify_data):
> +    if notify_data is None:
> +        return
> +
> +    data_size =3D len(notify_data)
> +    if data_size =3D=3D 0:
> +        return
> +
> +    BYTES_PER_LINE =3D 16
> +    for offset in range(0, data_size, BYTES_PER_LINE):
> +        chunk =3D notify_data[offset:offset + BYTES_PER_LINE]
> +
> +        # raw hex data
> +        hex_bytes =3D "".join(
> +            (" " if i % 8 =3D=3D 0 else "") + f"{x:02x} "
> +            for i, x in enumerate(chunk)
> +        )
> +
> +        # padding
> +        pad_len =3D BYTES_PER_LINE - len(chunk)
> +        pad =3D "   " * pad_len
> +        if pad_len >=3D 8:
> +            pad +=3D " " * (pad_len // 8)
> +
> +        # ASCII
> +        ascii_part =3D "".join(
> +            chr(x) if 31 < x < 127 else "."
> +            for x in chunk
> +        )
> +
> +        print(f"{offset:08x}: {hex_bytes}{pad} {ascii_part}")
> +
>  if __name__ =3D=3D '__main__':
>      main()
> diff --git a/smbinfo.rst b/smbinfo.rst
> index 17270c5..91b8895 100644
> --- a/smbinfo.rst
> +++ b/smbinfo.rst
> @@ -98,6 +98,8 @@ the SMB3 traffic of this mount can be decryped e.g. via=
 wireshark
>
>  `gettconinfo`: Prints both the TCON Id and Session Id for a cifs file.
>
> +`notify`: Query a directory for change notifications.
> +
>  *****
>  NOTES
>  *****
> --
> 2.43.0
>


--=20
Thanks,

Steve
