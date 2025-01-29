Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C561ACEC2
	for <linux-cifs@vger.kernel.org>; Wed, 29 Jan 2025 22:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738189433; cv=none; b=Jp8ywhBxXKgAgBeYEw7ds7SWyQHcsfEgOzlZk6HXbIkmljITI/aji8oMXubM8NGTim3Y09QSn/l57V3D49T/9+u5AC/vQIaz1MhCo1ersrVSaQHsNM6BuSZCi/ESkqUegzA8x4qoZ4FOIsEr9TlQUc04Jml7/wTkezhL+cWD9sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738189433; c=relaxed/simple;
	bh=legDdMj7/8HT7EQ3FnSqgdiVtZP7MnbJiA1muaK7Os8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=qIeGfIZvHjQLiJrlorIonHBSvdmZ//xsS+KQjETTCSO4TPXIIcOJTrI8pwUmAkKeU8tvMLb3d/A4FxZ2Xixzz5SdO6Mc8KAy91i+mII/TAgq2YUFUQqZO80Vy1BAgb4wUOU/8pW+uTCTuN0SpRnLD6yJcb3n4NaWd4PYGYbikik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CAzE/pTL; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CAzE/pTL"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-53f22fd6832so173174e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 29 Jan 2025 14:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738189430; x=1738794230; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Zn1VyREdaZ5O/jl4CgB3Z6vaU4evrMWsuCKgGuxXk6A=;
        b=CAzE/pTLqlCIYUcM2buqNoZ7X38XdUUmGA5P+pwp3wE6rNELHrB0qa3RxZu8dzZbZs
         w7Zu/Jn8CLR+cEHAuuJ5xO9taAJ5lBuYWapqLhHU/EKYJwo8UmIuCyF2XIgzBnYoZ/mO
         7/hdQOF20E1a8x29JzQv2pQ23dY7RzZJv847zp3eMIX8wlzFZm/KmikQqUGQeW8J0vEd
         rs609kXxW0HlvfZ3BQKym8iQr1GbNL/iWb60VyI0qplb4HCCefbi9uEvf0LjUYoV5+YG
         110BVgsAWyBVoP+9h1hRBs8uRnlBC/35Z6bdW45OIV6ilApOqmnUSBIOWNGxJyi8L+nx
         O8Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738189430; x=1738794230;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zn1VyREdaZ5O/jl4CgB3Z6vaU4evrMWsuCKgGuxXk6A=;
        b=sFt0LMl84GyGRgdwrocwBa5rkmkmDJpw1zD6OM0ZTX1rX5MRNb3dXstn9r5XKcdYhT
         lWB5Gza8zXvI58SOzu3j7mbpLplaPVCvn+an5I0Gxgc7WP/KsuHEgnsEy+LBT9MUVH2H
         +SN/dn0EAc7lHSAnOGIQYq8E2ZAziM1EOvJ6wlKu66J11o2yXWGbu5ao/FeeTwOydRo5
         GptwH8rZS37pk65dl6wOD924OPpE6SQYXf6GEDfarc8A8BzoGZr/ehPUYH2E5/iJJcko
         uFnifoS55kpo9Jm10yRL6PLNberv9Lt5kzPiCEMUNZ77h1EiTadssQZcmx9mMVTNVAh4
         tRyA==
X-Gm-Message-State: AOJu0YwbIdvmxI+ykRTlIGjGtZpwgcFl2IPpgKxmnb2vT7ZDL51djDll
	zky/UsXWxKxvYCi9cyPQVPTNho5PlZpgLtzWRjGkWixdNk9AtSUmUD8DjVu5K7r4KcereVqqUoF
	Yd5qw7PyVAg0nOBssmaiYQEZaRBUgq2jY
X-Gm-Gg: ASbGncuO6wvk8/o+HRMYDr9VabtB7wGYr6z+IHEVRx5jjUsGufcr1nkra9ITtqrmSvo
	L+afd76fWMFzCTuV3tpXYoMIS6ix+v+Wk30571MG+eVGND9deDPg1E53nguOwqUXILKTYUvMxRw
	==
X-Google-Smtp-Source: AGHT+IEkc4flHw8WQEbHV5Wj0iy7pcEzI8ZSyX+pOa+KjPqmmTf58P/XqPzrUs23ep+M74q5vFWYVW3uTfH/bk2O3nY=
X-Received: by 2002:ac2:430a:0:b0:540:1b2d:8ef3 with SMTP id
 2adb3069b0e04-543e4c3ca2cmr1399728e87.52.1738189429577; Wed, 29 Jan 2025
 14:23:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 29 Jan 2025 16:23:38 -0600
X-Gm-Features: AWEUYZlnwsHU9qPe3vRperR7Op39lR3XoUF2yzStJuUOf7P5_oZUW1E5y6YVahI
Message-ID: <CAH2r5mvdyi_6OZQ69z5zhiNapJZ778K_ZraY9dVpmAjgr7czSw@mail.gmail.com>
Subject: parse_reparse_point confusing function name
To: CIFS <linux-cifs@vger.kernel.org>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"

Any thoughts on whether the use of two different parse_reparse_point()
functions with the same name is confusing?  Should we change the name
of one of them?

in fs/smb/client/cifsproto.h there is one parse_reparse_point() declaration:

int parse_reparse_point(struct reparse_data_buffer *buf,
                        u32 plen, struct cifs_sb_info *cifs_sb,
                        const char *full_path,
                        struct cifs_open_info_data *data);


And in fs/smb/client/cifsglob.h there is a different one;
smb_version_operation --> parse_reparse_point()

        int (*parse_reparse_point)(struct cifs_sb_info *cifs_sb,
                                   const char *full_path,
                                   struct kvec *rsp_iov,
                                   struct cifs_open_info_data *data);


/smb3-kernel$ git grep parse_reparse_point
fs/smb/client/cifsglob.h:       int (*parse_reparse_point)(struct
cifs_sb_info *cifs_sb,
fs/smb/client/cifsproto.h:int parse_reparse_point(struct
reparse_data_buffer *buf,
fs/smb/client/inode.c:          } else if (iov &&
server->ops->parse_reparse_point) {
fs/smb/client/inode.c:                  rc =
server->ops->parse_reparse_point(cifs_sb,
fs/smb/client/reparse.c:int parse_reparse_point(struct reparse_data_buffer *buf,
fs/smb/client/reparse.c:int smb2_parse_reparse_point(struct
cifs_sb_info *cifs_sb,
fs/smb/client/reparse.c:        return parse_reparse_point(buf, plen,
cifs_sb, full_path, data);
fs/smb/client/reparse.h:int smb2_parse_reparse_point(struct
cifs_sb_info *cifs_sb,
fs/smb/client/smb1ops.c:static int cifs_parse_reparse_point(struct
cifs_sb_info *cifs_sb,
fs/smb/client/smb1ops.c:        return parse_reparse_point(buf, plen,
cifs_sb, full_path, data);
fs/smb/client/smb1ops.c:        .parse_reparse_point = cifs_parse_reparse_point,
fs/smb/client/smb2ops.c:        .parse_reparse_point = smb2_parse_reparse_point,
fs/smb/client/smb2ops.c:        .parse_reparse_point = smb2_parse_reparse_point,
fs/smb/client/smb2ops.c:        .parse_reparse_point = smb2_parse_reparse_point,
fs/smb/client/smb2ops.c:        .parse_reparse_point = smb2_parse_reparse_point,


-- 
Thanks,

Steve
