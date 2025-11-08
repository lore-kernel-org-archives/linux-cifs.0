Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAEBB199D8
	for <linux-cifs@vger.kernel.org>; Sat,  8 Nov 2025 13:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762609606; cv=none; b=sBk/KGatnnZXWbKbkIHMcbGf0eXBYb1epxV9+X6cp4xMZZnbytsXM4OQZOZpXKax7gupzRclrxGZsELaHCjo47vbglrsK3pHFbFHarJkpEc2jJGKTZDFWxMuvANZlkCozs6iBHooz2DqPakY7lWoXg86c6XTnOMbPYAszP6Pfv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762609606; c=relaxed/simple;
	bh=+fkDWHR+osQAcqrytuz6FeyuZXzuR3Ih9lCKLtqgZwc=;
	h=Message-ID:Date:MIME-Version:Subject:References:From:To:Cc:
	 In-Reply-To:Content-Type; b=byxXc/4Ju6agk9x4wkZve6v7TboB1GfAe3lmmB+c8AmyC6xFp4TGUaoTO07T0/Jpt2twJHZpQjqywDEkmC3NcfdfSqZmQHkjn1gKr8cRDd3hUvbRG+Zzhz3z0ljOwey5zwsKpz86ulycb+TCGX0zdH8+27uuWfIURc4QFo6xFQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TRo0ita+; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TRo0ita+"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47755de027eso11484575e9.0
        for <linux-cifs@vger.kernel.org>; Sat, 08 Nov 2025 05:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762609602; x=1763214402; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:cc:to:from:references
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tn1xqisdh6H3m4GIn9cRcGJFCW0rVCqi/DgvM3nOheQ=;
        b=TRo0ita+SbgpqsnTPKUhllwnxcruegST1XX+2r4dH3MgFFEjDAvtu/Gn1UT+7FlEaC
         c3WamIX0S200ULsPDbhNQ5L2YjTCJo/KReCy3badV5cjBUOiwWNa1SOcDKb6ivlORaf6
         y2hV0ZqnnEKk1k8YQzrQ+Sp9bSbGkCvRl4Lu7evouhO1OnrU0GvcbINYD93A/3+FEUqG
         nUytiJWpd34ipV1w5SnHE3pPKYu6lvIIRbrudkfx8hVZzrobMJP0adPKesvSlV5RdyqY
         nZk1sS61DjiXApHe/LK/z0PrrAOC8MxS/7diBx94LA6XJv3iOKsyeJ67QRELNC+9KhTS
         OyJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762609602; x=1763214402;
        h=content-transfer-encoding:in-reply-to:cc:to:from:references
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tn1xqisdh6H3m4GIn9cRcGJFCW0rVCqi/DgvM3nOheQ=;
        b=tRyrRnjYSn+VUIpqL4/Zu3P5fRt8PgCKBbh26Zege2fm8xNxY8d7iTmqBkEnFQrVaJ
         zyyOMF7dTzse70xbevxP4groykeHKLO6D5tf7f/r3pL2tiVWc4h4DpPmC2FeL2wC/+n+
         ku0cy7DyFx5bNEUcQ+HObZa4PuLyuwcBIP2lZ3jDEes8JE45vZV1WnYb2KyIeb4oYeuA
         js8DNI1ozk9/C5qRCUevyyIk40L61gN9m3tHflLDWiuz1tPKR+B73gpy3e/NsN9S7Thl
         BQncN6yYl1kpgPfGCAuEu/Gl/ZQNUzOBg8iEL70c+syWhmv/2LchnSZUXIYJ4NmaFPRN
         NoWQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2nfGv4crF+hqcRuS1XD6qBIRf4pQBTvHHTtsNovgnKBIvSYZHlhUiuSEjwIVR/OcObXF7hFis4RjV@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1gAlqOB4BJkeYos7tOQUmbIDcgxMTrxxPJyIqzksrd/Ys5hk8
	h874YvkUUhMZcsrtDsu7SPrHYhPG1R1PiLYOSLoRQcgNHXg4kQdnckGd36zglodNais=
X-Gm-Gg: ASbGncsG0E1cKNDRqIrZRc591ZTXDS7Q8jVcqwiepR9TQ/yOZgZLn7M6pl3/Lsk4wtW
	/BwdFpW2FLoiOGNSGDZ1iD8AqrHw0zAwfQt0J9PH1k8/8YgZUj//Dq+M6MctYjSHqpLSQmUb3qD
	lawutoafLIHk4lwWq84/ZpUT1l2rbmXun0BYpAJqfcllcxHQbIt27UIHC+19Vwf3vrT0/xMTQ0Q
	yjUL/moCywcdRF1kcf1FA6Sb/Sc0TUWgvETb8C2q4WF3zKGIVZ221t13F/cULfIDIhD/sCscEWa
	Dse6556VKo33USyEb5tFw7+e5u6Yn0RKk6HPoRT5780eYnGVYFwhX5j6aa2wRwn4NYoLeKFaw06
	c2whVVSceAZ2nkb2eN8GunLLZxa1+GqJQZnkkef/Il4SLKIen3Em1gBN6AIwh12wpoxer3C48+a
	Biy5OD1n/F6xAsj8GP41TUnLXJTumHQRR7vK0YXzKBYsNQR+j+gAnOZqZ6WL1+PPeRGFt/nlXS6
	eit0g==
X-Google-Smtp-Source: AGHT+IG3AWEQ5u7n+W8CorbTpkXf57cn6HCSKgM/hKvu6nXansRd409AEr5ZnuZAmxT24Ti/cwjfrQ==
X-Received: by 2002:a05:600c:6287:b0:471:1435:b0ea with SMTP id 5b1f17b1804b1-4777326eb58mr16020015e9.24.1762609602097;
        Sat, 08 Nov 2025 05:46:42 -0800 (PST)
Received: from ?IPV6:2804:7f0:bc03:f35d:7f7a:cb71:f7a1:a88b? ([2804:7f0:bc03:f35d:7f7a:cb71:f7a1:a88b])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3e41ed25caasm3533866fac.9.2025.11.08.05.46.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Nov 2025 05:46:41 -0800 (PST)
Message-ID: <7eba7884-3b54-4711-b5b3-5d82e1981acb@suse.com>
Date: Sat, 8 Nov 2025 10:44:27 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] smb: client: fix potential UAF in
 smb2_close_cached_fid()
Content-Language: en-US
References: <baf7ee5f-aa34-41f3-a00c-8e3b7686d566@suse.com>
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.org>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath S M <bharathsm@microsoft.com>, Enzo Matsumiya <ematsumiya@suse.de>,
 Jay Shin <jaeshin@redhat.com>, linux-cifs@vger.kernel.org
In-Reply-To: <baf7ee5f-aa34-41f3-a00c-8e3b7686d566@suse.com>
X-Forwarded-Message-Id: <baf7ee5f-aa34-41f3-a00c-8e3b7686d566@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Resending to include linux-cifs@vger.kernel.org.

Since there were concerns about a potential deadlock in this path (from Enzo
and copilot), I reworked the patch a bit.

In theory the existing code is fine as long as the refcount invariant holds,
but we've already been proven wrong in this area a few times. So I'd rather
make the deadlock impossible and WARN if the invariant is violated
instead of
relying on it being perfect.

@Paulo, what do you think about this?

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 018055fd2cdb..50074c9f125f 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -16,6 +16,7 @@ static struct cached_fid *init_cached_dir(const char
*path);
 static void free_cached_dir(struct cached_fid *cfid);
 static void smb2_close_cached_fid(struct kref *ref);
 static void cfids_laundromat_worker(struct work_struct *work);
+static void close_cached_dir_locked(struct cached_fid *cfid);

 struct cached_dir_dentry {
 	struct list_head entry;
@@ -388,7 +389,7 @@ int open_cached_dir(unsigned int xid, struct
cifs_tcon *tcon,
 			 * lease. Release one here, and the second below.
 			 */
 			cfid->has_lease = false;
-			close_cached_dir(cfid);
+			close_cached_dir_locked(cfid);
 		}
 		spin_unlock(&cfids->cfid_list_lock);

@@ -480,18 +481,52 @@ void drop_cached_dir_by_name(const unsigned int
xid, struct cifs_tcon *tcon,
 	spin_lock(&cfid->cfids->cfid_list_lock);
 	if (cfid->has_lease) {
 		cfid->has_lease = false;
-		close_cached_dir(cfid);
+		close_cached_dir_locked(cfid);
 	}
 	spin_unlock(&cfid->cfids->cfid_list_lock);
 	close_cached_dir(cfid);
 }

-
+/**
+ * close_cached_dir - drop a reference of a cached dir
+ *
+ * The release function will be called with cfid_list_lock held to
remove the
+ * cached dirs from the list before any other thread can take another @cfid
+ * ref. Must not be called with cfid_list_lock held; use
+ * close_cached_dir_locked() called instead.
+ *
+ * @cfid: cached dir
+ */
 void close_cached_dir(struct cached_fid *cfid)
 {
+	lockdep_assert_not_held(&cfid->cfids->cfid_list_lock);
 	kref_put_lock(&cfid->refcount, smb2_close_cached_fid,
&cfid->cfids->cfid_list_lock);
 }

+/**
+ * close_cached_dir_locked - put a reference of a cached dir with
+ * cfid_list_lock held
+ *
+ * Calling close_cached_dir() with cfid_list_lock held has the
potential effect
+ * of causing a deadlock if the invariant of refcount >= 2 is false.
+ *
+ * This function is used in paths that hold cfid_list_lock and expect
at least
+ * two references. If that invariant is violated, WARNs and returns without
+ * dropping a reference; the final put must still go through
+ * close_cached_dir().
+ *
+ * @cfid: cached dir struct
+ */
+static void close_cached_dir_locked(struct cached_fid *cfid)
+{
+	lockdep_assert_held(&cfid->cfids->cfid_list_lock);
+
+	if (WARN_ON(kref_read(&cfid->refcount) < 2))
+		return;
+
+	kref_put(&cfid->refcount, smb2_close_cached_fid);
+}
+
 /*
  * Called from cifs_kill_sb when we unmount a share
  */
-- 
Henrique
SUSE Labs
