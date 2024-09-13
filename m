Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDC61F5FE
	for <linux-cifs@vger.kernel.org>; Fri, 13 Sep 2024 14:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726237665; cv=none; b=bB1BfIwECBMjBffAH4ztJQmd3aBMDFIlc2v1io+4lHKs3hvo/Mcp2O9g9v25gWhFrjxe7PRcTMSeOZ4syzSqfVTcRp+16Zx3j3peknljq8YROBAJjj5ztxHctCbo6xpfk3IpKRYcHM1fwV5YJ9RvR6kzZuwzPedaPg8l2vP/fz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726237665; c=relaxed/simple;
	bh=BMbMBrEaXkhTceyFD5PS9SyMkQGp/UGDAA5Q1Cswrp8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Js9GZwEjK56wEf5S9/7oHtu+CtVLDu518Qi6qKhCSbUaeKlafwgH7h0z7kM22FcKWCBAmDlnz2+o6I7gfzNiodSK60+ZvnBihphfwAh/I72egvP+u1u/u3+e+qTLuE0YoSHF9tx4pVeM1wkObkhizRxRx30s5NCwwJh3JRGBBoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bIvkCBhm; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bIvkCBhm"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a8d446adf6eso120813266b.2
        for <linux-cifs@vger.kernel.org>; Fri, 13 Sep 2024 07:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726237661; x=1726842461; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cIYrA3fApmj/VA0YxzbjS7RepDkx7u7YBk2EwmvjZUY=;
        b=bIvkCBhmIp4n+MBm26EsxhpXZ3XV92HnSJCArtJmIyK2bg9R8g1Gg4QPV19JrikDHT
         WhVOiidPWmUiKS29ETaYT5sjZ+dyiMGq70E/Oa1k8I9zKu7HOexPBdJGyVQIIMBnvYJQ
         9nEjviBBt6O2ZUPNnoe06Z8BhPBgrURUiRtskNYoXQb4RGI7GNgCaucTZgSxDAT97TwT
         cSFQZcjtScjnHv1OrxgYI+hJy+cowjtYU2+Q8AnWM/KoWAPxpcP4BiylvaWAaPIYy/aI
         9Z9xMvC0eANO+jRSHL93SLi6P90ihf53Jf/T93w1gMMxA+XHliNwbPgeowRXe//THs4a
         UvXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726237661; x=1726842461;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cIYrA3fApmj/VA0YxzbjS7RepDkx7u7YBk2EwmvjZUY=;
        b=dIoJ+W+XrDpB+vsPPClTSvOUoMIbnlRQs2DOqHq/E/wx4VydJI5evzV5YS42dxUEE9
         porysbQXYAa3k4tdEnD66UKvmkr4K5L5Tv98bAPkEXqAN4vbZ+JeEgD/xNcC7Kk1tnpn
         Yg7bTk2Sj381pKrAcDxR/clQF1RfQFrBivGFWYSmhJacJW1N/n8JHoRP3swK8ByUOlGj
         kCAAX3WS/iC0pN6A5+32Iutun3NL9xLiRg0DbYnSQPo/nXXE49uLhLromGN38N1OWBWe
         Wpssf38FBLy8Jp8p6sxbbfD2BbnFGEoIOLoAOE5QP5iy7H/gqAI4ARqzy8LvnGE3Az8b
         PjvA==
X-Gm-Message-State: AOJu0Yy1MKqgrq5UICRrRg6bF3fs3YM1SEg+VLAgSwbFwV4U+XlmLUPV
	kfnuXL9mWjjPGmwvks2kLiLGpE8LJcWKHNmfwXcCGQtWVpWnIbXJukiuZgRizWRzafDRjVBggo9
	i
X-Google-Smtp-Source: AGHT+IHeEU4dbjVKWsLajdZ7hdwLEy20t/Cvly9cMfhULZ8oyu6RhvfXJPRZvQ+wAADzAHk5RhZ6cA==
X-Received: by 2002:a17:907:e90:b0:a8d:1303:2283 with SMTP id a640c23a62f3a-a9047d1b022mr241062266b.30.1726237661451;
        Fri, 13 Sep 2024 07:27:41 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a901292f81esm323143266b.1.2024.09.13.07.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2024 07:27:40 -0700 (PDT)
Date: Fri, 13 Sep 2024 17:27:35 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org
Subject: [bug report] smb: client: compress: LZ77 code improvements cleanup
Message-ID: <7eac0abe-1ea6-467c-a560-fa70dc20385e@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Enzo Matsumiya,

Commit 13b68d44990d ("smb: client: compress: LZ77 code improvements
cleanup") from Sep 6, 2024 (linux-next), leads to the following
Smatch static checker warning:

	fs/smb/client/compress.c:311 should_compress()
	warn: signedness bug returning '(-12)'

fs/smb/client/compress.c
    292 bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
    293 {
    294         const struct smb2_hdr *shdr = rq->rq_iov->iov_base;
    295 
    296         if (unlikely(!tcon || !tcon->ses || !tcon->ses->server))
    297                 return false;
    298 
    299         if (!tcon->ses->server->compression.enabled)
    300                 return false;
    301 
    302         if (!(tcon->share_flags & SMB2_SHAREFLAG_COMPRESS_DATA))
    303                 return false;
    304 
    305         if (shdr->Command == SMB2_WRITE) {
    306                 const struct smb2_write_req *wreq = rq->rq_iov->iov_base;
    307 
    308                 if (wreq->Length < SMB_COMPRESS_MIN_LEN)
    309                         return false;
    310 
--> 311                 return is_compressible(&rq->rq_iter);

Was this patch ever sent to a public mailing list?  I don't see it on lore.

The is_compressible() function has some weird stuff going on.  It's an is_
function so it should return bool instead of negative error codes.  Here the
negative error codes are treated as "let's compress this".

check_repeated_data().  It's better to name boolean functions something like
is_repeated_data() so people will know it's boolean.  This function takes the
sample data and compares if the first half is a duplicate of the second half.
The only way I can imagine this happening in the real world is if the file is
all zeroes.

check_ascii_bytes().  Rename to is_mostly_ascii().  Get rid of the bucket struct
and instead just it make an array of unsigned int.  Then the checks are
simpler:

-		if (bkt[i].count > 0)
+		if (bkt[i])

The check_ascii_bytes() has some micro-optimizations going on.  I don't think
they're necessary.  I can't imagine how this could show up on a benchmark.  Just
do one loop instead of two.  On my computer I'm able to do that function 12
million times per second, but I micro optimized the function even more and now
I can go through it 20 million times per second using a single loop.

static bool check_ascii_bytes2(const unsigned int *p)
{
        int count = 0;
        int i;

        for (i = 0; i < 256; i++) {
                if (p[i]) {
                        if (++count > 64)
                                return false;
                }
        }

        return true;
}

The trick was I got rid of the threshold const used a literal instead.

The check at the end of is_compressible() should not treat negatives as success:

-	return !!ret;
+	if (ret == 1)
+		return true;
+	return false;

    312         }
    313 
    314         return (shdr->Command == SMB2_READ);
    315 }

regards,
dan carpenter
