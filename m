Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEF3276057
	for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 19:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748373636; cv=none; b=cAYoUpHKosPpblUgAYTJ7YCjvDZXH4TH7GNve5ZxPUO0lWaCiqQmoF+FRIwLBGij4j+ezZH8W0pG5g5qrfPmc6lo/ryaLv58Es/iE7iaoeA6SCoQWlgScSo9/5GugByQenweTl71vjdfrXIDh9vbE0BbmxTlzbM2UT9Sz1Aj9Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748373636; c=relaxed/simple;
	bh=2XKBLs+XHUMiApww7Tw5HUUTWvx75o0tcvhmirv8KZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IQmWcgyGoMCZ6ttll214/OKUEbahrEbVUsvcmm1Z03VdERj/Gcc3NrSXydg6T1FI0F+TXpxVz6yoMO/aAl8Rv8h+9GOommSK9owoo/u5mvkLuazHy6nDKfDSyr6vevhz0mivTuLo5R8ZqO6YGtMA4YjqD/XbBlweVbVoKNFn6Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NWFp0GxB; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NWFp0GxB"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a4d152cb44so3418012f8f.2
        for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 12:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1748373632; x=1748978432; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WNzbuKat6s23hkuhBUIQt+6jrWxjVsrrpBjcD2JzQZ4=;
        b=NWFp0GxBIpZtrY7rvAume1dHw01crKf8zX4ulLFATPbeS/flPW48WT8K0Yea5IA/Yn
         VTrSYrERBQlQCtxiGSV1TRT2aFvXLUr4zKN21hMdcKsukzTRbrZ9TAA0ujSOZ2FFYsu6
         KZIwNvDziXZ5xD0QPUWcxHnrae+/bRqKGM1NWePNxLoI+OdGHiuFz6NHZwfSFLOCDVql
         RAtsVVwdjiT/bsHgTy19jzRp+3IRlYhyy23BILCr59aPd60JrAkG1BeVebRJkU2weYeI
         4oFWPGZsJJKPwKH4ZIMlMb6/BxDyIFGAFJgLKpTsb4WqOWSWOX354a3DimBphDkUoG85
         8/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748373632; x=1748978432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WNzbuKat6s23hkuhBUIQt+6jrWxjVsrrpBjcD2JzQZ4=;
        b=DJ1psqQcjoB4ciMRg+22ayFtsDN+BP5uznxOkZeTnsv664Cj0lmQgLKIN97E05Ddgr
         A3uO9Le2cPaBKMgnXaW9IjGmgJTMIgrsjjvBF3m4fY5zv5gbTHonMKHv7IWmFZhCJRKr
         lXIR2kgYK+onbhBHfcfcQoKEkI/C7ZHpEadMA38M4r8kzZCRoVDc46hX18AjeuUiO12H
         LPSm63RY9gueWyqXCQ4ZNzbRsVpbh7YuYmBR5VH7mpz7BPmRkujzPRP+3KsHDEnJxY0c
         zNK8z+b51kcRQYBmCZRifPcjYJLLIurMhPpQxakRI+j8wWc1fCkgiyfc5cqMqlHSbNn3
         goIA==
X-Forwarded-Encrypted: i=1; AJvYcCUPM1mO5ew2eAMgH/kee6JMdG4Q3y5nmV7tjFyIAJXg1iMCzxP8alIuy9/c4idMfKz5HoJMyfP3JCOW@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt/590cCcMt5P+xdOXEY0OVyN8u7ZGW3glqgqIFiKgbTVMUQ3b
	674JL/jXIZAGMt8qIDux/8yXm3C4wQ/Z1lCOIAm7n63ToK6I4joaBOYA1rIQ/4lycTc=
X-Gm-Gg: ASbGncsw4Cvi7vdcV95jSMrQMP30gmQT/N2jMNJ5t9oohyvXcqexJamho/O7v+DRfOn
	T+ZZerZJ3axD/L2Bf+0ZZJsJZJ/YdRr91IkZl1xBFw0DDMViUW2/AfmeIDUCoZSPnJeoRlEEeTk
	VLmy8wqg3/f1yvyriq2F5ndraKVdis953e0qSqY6zxLWoDDbmp9s6zYODUSIQSWY49/auMdvxLR
	JreQVsIggUQS0jL8GeYbq9XmhnVceR7KXSvkQUE/A4nNZA6JQbdJTFSbejAacDC3eI9vI+KOcxH
	RDXje9wi57qWsrVXHtMz4nTz/vDAlSOjMV5DBDLixUEljggmcpviJs+K6Uj6
X-Google-Smtp-Source: AGHT+IFgNhAr9x8Kz1W0d0X9DBxMjvBkA88tvTnh5T/mbdEA1OCwGht1C1zCvJyfThbHmdacRC6RwA==
X-Received: by 2002:a05:6000:22c1:b0:3a4:e0ad:9ab0 with SMTP id ffacd0b85a97d-3a4e0ad9c8emr3655328f8f.30.1748373632442;
        Tue, 27 May 2025 12:20:32 -0700 (PDT)
Received: from precision ([2804:7f0:bc00:cf9d:7dfb:3497:3dc2:8e58])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-742a982b86esm19068026b3a.115.2025.05.27.12.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 May 2025 12:20:32 -0700 (PDT)
Date: Tue, 27 May 2025 16:18:56 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Paulo Alcantara <pc@manguebit.com>
Cc: smfrench@gmail.com, ematsumiya@suse.de, sprasad@microsoft.com,
	paul@darkrain42.org, bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH v3] smb: client: fix race in smb2_close_cached_fid()
Message-ID: <aDYQILpDA0EqzsX7@precision>
References: <20250527184213.101642-1-henrique.carvalho@suse.com>
 <44fb26b3d061287bf1cf8ec458adc8a2@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44fb26b3d061287bf1cf8ec458adc8a2@manguebit.com>

On Tue, May 27, 2025 at 04:06:01PM -0300, Paulo Alcantara wrote:
> Henrique Carvalho <henrique.carvalho@suse.com> writes:
> 
> > find_or_create_cached_dir() could grab a new reference after kref_put()
> > had seen the refcount drop to zero but before cfid_list_lock is acquired
> > in smb2_close_cached_fid(), leading to use-after-free.
> >
> > Switch to kref_put_lock() so cfid_release() runs with cfid_list_lock
> > held, closing that gap.
> 
> Does this mean that SMB2_close() will be called with @cfid_list_lock
> held?  If so, that's wrong.

What I mean here is "Switch to kref_put_lock() so
smb2_close_cached_fid() *IS CALLED* with cfid_list_lock held". Poor
wording on my part.

The lock will be released after cfid is removed from list.

My argument is that cfid can still be found before locking
cfid_list_lock in smb2_close_cached_fid. Here is the current code:

    static void
    smb2_close_cached_fid(struct kref *ref)
    {
            struct cached_fid *cfid = container_of(ref, struct cached_fid,
                                                   refcount);
            int rc;
    
+           /* kref is 0, but cfid can still be found here */
    
            spin_lock(&cfid->cfids->cfid_list_lock);
            if (cfid->on_list) {
                    list_del(&cfid->entry);
                    cfid->on_list = false;
                    cfid->cfids->num_entries--;
            }
            spin_unlock(&cfid->cfids->cfid_list_lock);
    
            dput(cfid->dentry);
            cfid->dentry = NULL;
    
            if (cfid->is_open) {
                    rc = SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
                               cfid->fid.volatile_fid);
                    if (rc) /* should we retry on -EBUSY or -EAGAIN? */
                            cifs_dbg(VFS, "close cached dir rc %d\n", rc);
            }
     [...]



