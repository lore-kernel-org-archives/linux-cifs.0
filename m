Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E4D330B15
	for <linux-cifs@vger.kernel.org>; Wed, 28 Jan 2026 17:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769620680; cv=none; b=g4YVqe51SGxMA+3e1DSdnVwSCgbAu9J/f2dbU21Q6W1TJVCycmBvc3MAbtzqAb9eSkYT5uJSEbJw8MRClae7G6C27kjFLKs87FkdCc1VD9typLwRhC+KJF97FOyQwSW5AizqlePiofNmTyuKIV05AV5Th3nN7HG7il+fHO4EUiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769620680; c=relaxed/simple;
	bh=BGqnVmp1eJvMacXoI673ldZKkJTfLCVUC3t8ZxfuCwY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=skY05bdls1rQ3O70zqjgXaEONtPkadtin1RDVzEzzxpmITjz2gIxQ3ZX+8f67MMjOvT/zVNToRQfblWmIUQQNqzvY39gSpmleMwFBkAsHNlN8duEeGf0WmAJvR6/dv3DcB2YYRoMy6pJYWPPB2mFgWiQikn8eWcLG2mbkhWXCwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QCIYXqIX; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QCIYXqIX"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4359228b7c6so83005f8f.2
        for <linux-cifs@vger.kernel.org>; Wed, 28 Jan 2026 09:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769620677; x=1770225477; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6AJCBY/tn9iOXEaPRhRwwP52ntozIkhH10hpJi9Uxfw=;
        b=QCIYXqIX4S1leR4PqjDNaKfuzvj8PYyES41JLnLA4lgg/zA+XQ5FiEagKlSznLW15B
         4H1ymrd6jf8WGQxX0JYtJHEr5oHTtcyUVDcs9X45aLledpLSfNbWUzWI4v9ZPKaMHiIy
         aiTsi929c9RFpk5B49MB8MoTJvUOT8hpBMMHXXJx7iA634yJny8Jy0ET3sIu4VPkDhZ+
         o0LFAMpPh+XRs81FfCuDsKVonGrHoYNgOpK20PlKO3XZ6GEG1kk44zdNdNxB5pgnv+WT
         PgtGCTehQUDJ1fiqIOoQOAoVAUsBfK0rMZKVMYgCt69Vs6yQVwftVI+KqKGLKQAaVMyv
         GTGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769620677; x=1770225477;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6AJCBY/tn9iOXEaPRhRwwP52ntozIkhH10hpJi9Uxfw=;
        b=Ajrjj1V8fmlQKn47A6ImeBg9gwr0192cmvEdymFdpYk8VavR2Ol4KUKlOKLpbXjy2Y
         o6VBUfHYA2krdvvZcLJ7G2bSEoE5m+iWdqHf+zG2J99qTAzolAHSSSWkQcojMZ3hgh7+
         8VmUgluGmP+MM3wTNNYGx8aht2qnVnE1d/mOrukPiDMQ6YiDqHRG1mO05snkUcyrWTLd
         DcUnsdl+7LtDJwZ7xlsdoeAVI2R6OiyX91eUUKFgEUXxN6FMQkK9wtV/7NfyyceqxnSm
         ux/53twwCAkqA0JuCx3ljRmETpZ3ZgBK3JbunZ8L4gsZmZ36uqA2Qpg5HOxValkGr8Ay
         mSiA==
X-Forwarded-Encrypted: i=1; AJvYcCVgwNH3UBqz+4Ge4k7y5zCxt0yXbQc75y2KuHQPPdIEGMLLgBJlnVzoYOOIZ1CKcTOgEbaLApu5qTRE@vger.kernel.org
X-Gm-Message-State: AOJu0YwvQ4mOFjAzYBZp0Km4O8M19Adbdw0OswkQRbMOI2c8V0llL6E2
	mGh5WDrRlCnNHQVe6IGWA8X57u4OvDK0emG8kE5HjrQJspFp8glKxV6NQzj5QRMmyjk=
X-Gm-Gg: AZuq6aKxeCWDrR9FfSQ+CMyKN924HBT3/dzM6bYfGX3M5ghDS7lCSEZ4kbpBQXKWQM0
	ohfDMUCuiFuFnInZDN7VZWhM2jMy4/jtxBj2UCFBSSRpDIO5uUiOCNZGeyQ+6IVGKUispvgiOup
	qcAWFRWC2SRGAl8cuzEN7bc2En05Eo2YMT4PKbWdLPG0Xz6BKs0MfvQcbi0OzgQbcT1b+cQU3CE
	g8POX1lYLUYpPjc7EOXd5KZ4IPJlGe0IEFZ1fYIcGr8ypwehsy5/SqR7bjRXgiGUm88rf4O8N1F
	3rqswaolAmrcoQHy+NMfSVfpgtD1k7Chcpx417p9k78O+TnBj4GpvWnHVL8FZXQJoRELjAqG8og
	x5Wtypoy8qUngA9svdUBsyqE+aygoNWlvoVWqfH0viXlck5u8tq0hn9KjgGJTK06Ft/qGf6ai5D
	49Eer+0A3cKd5I28FwW0U=
X-Received: by 2002:a05:6000:178e:b0:430:fd60:940f with SMTP id ffacd0b85a97d-435dd04c33amr8035567f8f.14.1769620677507;
        Wed, 28 Jan 2026 09:17:57 -0800 (PST)
Received: from precision ([2804:7f0:6401:4338:fe12:6a4e:72af:4ca4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7a16cf8f2sm3841611eec.7.2026.01.28.09.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 09:17:57 -0800 (PST)
Date: Wed, 28 Jan 2026 14:17:51 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, ematsumiya@suse.de, 
	linux-cifs@vger.kernel.org, stable@vger.kernel.org, Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH v2] smb: client: split cached_fid bitfields to avoid
 shared-byte RMW races
Message-ID: <pkihyoewqokamtfcawpoe7mpqqu4rf7zwtfnymd5dxxb75cg64@efxg7to7rzqk>
References: <20260127160128.243441-1-henrique.carvalho@suse.com>
 <CANT5p=q8trAvAMwVOczAuet2qFV_m0w9a9PJdJEtPhAsf5DGsQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANT5p=q8trAvAMwVOczAuet2qFV_m0w9a9PJdJEtPhAsf5DGsQ@mail.gmail.com>

On Wed, Jan 28, 2026 at 05:03:03PM +0530, Shyam Prasad N wrote:
> On Tue, Jan 27, 2026 at 9:39 PM Henrique Carvalho
> <henrique.carvalho@suse.com> wrote:
> >
> > is_open, has_lease and on_list are stored in the same bitfield byte in
> > struct cached_fid but are updated in different code paths that may run
> > concurrently. Bitfield assignments generate byte read–modify–write
> > operations (e.g. `orb $mask, addr` on x86_64), so updating one flag can
> > restore stale values of the others.
> >
> > A possible interleaving is:
> >     CPU1: load old byte (has_lease=1, on_list=1)
> >     CPU2: clear both flags (store 0)
> >     CPU1: RMW store (old | IS_OPEN) -> reintroduces cleared bits
> >
> > To avoid this class of races, convert these flags to separate bool
> > fields.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: ebe98f1447bbc ("cifs: enable caching of directories for which a lease is held")
> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > ---
> > v1 -> v2: Add Fixes: and Cc: stable tags
> >
> >  fs/smb/client/cached_dir.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> > index 1e383db7c3374..5091bf45345e8 100644
> > --- a/fs/smb/client/cached_dir.h
> > +++ b/fs/smb/client/cached_dir.h
> > @@ -36,10 +36,10 @@ struct cached_fid {
> >         struct list_head entry;
> >         struct cached_fids *cfids;
> >         const char *path;
> > -       bool has_lease:1;
> > -       bool is_open:1;
> > -       bool on_list:1;
> > -       bool file_all_info_is_valid:1;
> > +       bool has_lease;
> > +       bool is_open;
> > +       bool on_list;
> > +       bool file_all_info_is_valid;
> >         unsigned long time; /* jiffies of when lease was taken */
> >         unsigned long last_access_time; /* jiffies of when last accessed */
> >         struct kref refcount;
> > --
> > 2.52.0
> >
> >
> 
> Does making them as separate bool fields ensure that compiler does not
> optimize them into bitfields anyway?

Fair question, I hadn't thought about it.

However, according to C11 standard, that is not allowed:

        2 Except for bit-fields, objects are composed of contiguous sequences of
        one or more bytes, the number, order, and encoding of which are either
        explicitly specified or implementation-defined. (6.2.6.1)

        15 Within a structure object, the non-bit-field members and the
        units in which bit-fields reside have addresses that increase in
        the order in which they are declared. [...]

> Ideally, we want to protect these fields with a mutex / spinlock,
> which doesn't leave us suspect to such issues.

So having them as separate bool fields should be enough.

-- 
Henrique
SUSE Labs
