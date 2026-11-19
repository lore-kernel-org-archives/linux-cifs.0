Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795102357;
	b=MIN0SmNwHn4eA0AhowA9eJ3vs3eXTdNU2UUx8A1iPHdH/ssSHUzj0NOyJtYfB80GQdqE
	 h4MR7hJ+hhEZu74yRqp682mml3OOfmN41R1xOik9tDutbHJqz06dNVszl2D86xLgr8UlS
	 aiF1lyTBFGi3RuGHiqmIpkhvlEDrY4BJevgrev7fJdbYAmoIhPY/Qlf54Sp5QGgIg8YH9
	 JO4DiEgsBmWSQxO4e46K1UtmIAnh/zDGInHk3/gJyP2AqofSks+WKRZ+DFoz2BrctiK9c
	 94RmQWXdHne5ipesQ+gt/ojRfqa4uJZf+TodQLjlpNTDsPV6sLr/BDyU7DkMyZbVUsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102357;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
	b=IYVxt5EKFjHm2Csq/1zpAHzzkGgwE/w21pkvHsH0dLgSKEkxGJ73FUqjdUBFhlKkJig2
	 NCCaAMtqKSLw4L225LcdJGpYJB3qlklYkpNgHIGAhGGv+VPYUjqxszK9lyZihzHczFt/w
	 VvdHeowvtCTmJoymmcyXb1ue818o3clPENTgxG2VpZtO6l7h/K38t9MW+wz3FTI3zuPoD
	 K+aTuoLPtyMeA9/Fjx+eLHd/gkyk87cmqMKrbHm6gW1jTntN1vVIwK/9YgZE86PznIcUf
	 GAwQyH272E1XhkFevh5TQSz471XgtlRmrlsPjLODWVHUHTlYBir0zzOvuPhOuUmDy4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EriZpb1V;
	arc=none smtp.remote-ip=209.85.208.173
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D69D606A33C
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 15:32:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D69D606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EriZpb1V
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3acff56a300so24745571fa.2
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 07:32:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795102355; x=1795707155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
        b=EriZpb1V/2zno0fmMO54HL34Ty+nBUS/4UO0C6MvrvxZFEYE5Wk3AXr9C+UsTd1EKu
         e7VRl67WTxEo3VDt+hkZtLmFiEHnR1zJiLfC/Bq9BJKAFBDFohxqHF5Q1gg0wFZRWOaP
         GGmxEOrPJV8MRv3PkF03h/86SpZPKw+8KkyhjjjSRymeueMiKP4mQ8rtd0qNdqm/fzoE
         MNeg/d90yqGf1ngIGXcTcG1X2LenLIoGjIMBxdm9LKyp4bnMI848kU3NoOJqH9CbrAin
         fitPeVcUyIY+ve4q72M8iKNlPUyICj34RV6qW8QMN0CuPmRvl1c9rcr7e4C4EfPjdOm/
         0D9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795102355; x=1795707155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=f7T2TmAinoSSVrUkDLWCSHpGLO0VMoU6RTqJIGDHf8c=;
        b=OpIIiY43kQJOTwAGBZIrzfULIKdN5EaiWD6Al8hUZCc2WBtIaGguj2aLX0xwMO74Ad
         m+9kDfUul8KFspxVgNS+T5VtiJyHDwyCDgWyEc2n6qHcZ6meIJFcDupfr1WgoqBJGDLn
         Egjzym5VqXxhuKukGwX5ADVQE4wVlrCADUQPB58897vpuiWKoquV3NBO06Nz4aStjjvL
         j3PKJdMA5REIEDP3kjzn02LZxdAb2botwFQIgPid6KyXX5twHSVUeb4lubXlQZPahDvo
         SNUlIuy4TUySiCou0EIDI9+2fAadFAYfwTW0PIQzoB/N3A/ELcriPWBY26fIyPycqND/
         XEVA==
X-Forwarded-Encrypted: i=1; AL+hErE16/q0ngIDgRoapwiDjiVmMW2Gnwl1wvs5WG359+I5Fzh6KRWZVI31Lwv0b6R23Lg4zpktFgSZMDog@vger.kernel.org
X-Gm-Message-State: APuU4Z9n28naTfmSdbFiTWhVpF1Q5hvN3GXLG6gbs8k66E4QEJDrEgm4
	L4I04BKvgd9m3vVOPM/ntvHHeMLCC/1O3lTDLeqNxwhupQhpHb2tH4h4
X-Gm-Gg: AZFdTZfcPD4s5rBTEYibTrv2+z4bJQOqxv1fJYFEqbTkRwS7+fEqVsgOM5uYjBNVYNF
	2DqghxcOJBIjYkkAi06IMbFLL5Jpm5OXKnmfuTjTmGXG8bhGQ/KSArr5R4LWD99d/BIP7WdkE/n
	1EFzLFLw0jYUrNr/O0Db6nKOtnqUiVqhxuEPWM09IM303KLkjgdJ6THhXtHm9NSpesbFQInI3W3
	ZhT493NK+wNbAndXh3LvFkwJt9DbgvvH9N5Ej9Bdevo2ef4bqSF+IiTBGqd6+7sYU/zcWADRlZN
	7lsIQLavzAzRl7f1ePZU5QuimZ/ZMJOYT5fGn9gYCEkmOnn2mUgFtjroriHGpIpeH08qe5rZmzG
	KVv0wWAUC8sh6SN7eX3pSEZOENUP4JUt3PqSPpBLhkcF0oYwweASidr+wZf84SvqvUHaeNObVLH
	9oOt1vKfb42TabkAFl9FtWAJ/e8CF8XWCBMkupcRB2UZkxVZwKjhMd+sbc/sjrYvJJhZ79WVuF6
	ljgp2+6RKb0+uf3HKajChUbPaTvHB6Lxm8fYG+XFPhKanO/xCCFBef8ftaxXXuUHPehRtiJxIBZ
	6p7UALfOw1T6ocgZXHU78YXHIF/c8plpPpCW53qD1B1lp/9hD6Nko6zl8fFhtW2zcEl4ZcFYf61
	1lMEsHv03QzJNdn3jCdBLQljGcWBgT6lFJwSykpRjV7iImY8GzcJ7s/px7mk=
X-Received: by 2002:a05:651c:a149:b0:3aa:ef31:e51e with SMTP id 38308e7fff4ca-3ae7fa644d5mr1204161fa.19.1795102355312;
        Thu, 19 Nov 2026 07:32:35 -0800 (PST)
Received: from Lauri-G-Pro-14-M4.intra.lakuz.com (n2vuxegwnwppvr5uhf9-1.v6.elisa-laajakaista.fi. [2001:99a:2ab:bb00:c16c:a39e:e605:54b5])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3ae6ebe67e2sm11532121fa.33.2026.11.19.07.32.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 07:32:33 -0800 (PST)
From: Lauri Gates <lauri.gates@gmail.com>
To: koraynilay <koray.fra@gmail.com>
Cc: Dave Chinner <dgc@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <christian@brauner.io>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF buffer lock
Date: Thu, 19 Nov 2026 17:32:22 +0200
Message-ID: <20261119153222.65195-1-lauri.gates@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
References: <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, Nov 19, 2026 at 01:00PM +0200, koraynilay wrote:
> It doesn't seem like an FS_XFLAG_NOSHARED flag would touch this new
> change, but I thought it was worth pointing out, especially because this
> patch would also add FS_XFLAG_PROJID and a new FS_FILE_ATTR_XFLAGS_MASK
> to have a way to include both legacy and newly added xflags, so
> FS_XFLAG_NOSHARED would maybe also go there (correct me if I'm wrong).

Thanks, that is useful. I agree it would go there, whichever meaning
it ends up with: as a newly added flag its bit would be added to
FS_FILE_ATTR_XFLAGS_MASK next to FS_XFLAG_PROJID, since your
fileattr_to_file_attr() masks the value with it as well as the mask
bit.

Your mask also changes the question I asked Christian. With it, a
plain "may share" flag works the way stx_attributes_mask does: a
filesystem that sets the bit in fsx_xflags_mask answers, and one that
does not (btrfs today) reads as "not reported" rather than "not
shared". The inverted meaning was only there because file_attr had no
such mask.

One constraint for that case: the flag has to stay out of
FS_XFLAGS_MASK. As I read your fileattr_to_file_attr(), every bit in
FS_XFLAGS_MASK is reported as supported on every filesystem, so a
plain flag there would read as "supported, not shared" on btrfs.
Outside FS_XFLAGS_MASK the flag is also never seen through the legacy
FS_IOC_FSGETXATTR, which masks with FS_XFLAGS_MASK. That is fine,
since only file_getattr() needs to report it.

Christian, with this mask on the way, would you take a plain flag
(say FS_XFLAG_MAYSHARE, "may have extents shared with another file")
that filesystems advertise through fsx_xflags_mask? If so, I'll build
the RFC on top of koraynilay's series instead of using the inverted
FS_XFLAG_NOSHARED.

Thanks,
Lauri
