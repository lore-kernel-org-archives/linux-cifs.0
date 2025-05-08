Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8462B27AC3E
	for <linux-cifs@vger.kernel.org>; Thu,  8 May 2025 15:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719615; cv=none; b=kHiCqHQst2STw3OlqGr87BPwkf492veN2Ja5DY5Qnm89O4q8OL+37dRhWmYFU8UWsukRT2JuZP78XeAptKI1mW/yCavNm8rnqJop6Uyx2Fc0KuJAv5hLDm3waFywe/FIoAN6x1z3JYKCtp7eScr0Nx4zyCxyoMUwIHY4w3EQq1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719615; c=relaxed/simple;
	bh=WIUGFWydcCAGFGWPsKPIp8IONTSNtXtiPL7NBNeAJ6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p46mNbMAaRJKuL2H6AsieVX5fRv7Agp3IdMIYPzi4BllTxK1i+2y7hd6li76oE6M/iRVqTifmQnsJnYA8NS9LTyuPeN2iXf1F5KnS/9icWgMryutdPoRSu1GDq/i5mfPC0FHjadKGSSWqjjloxLf+WqybsnuQm/GVzQWIRIdTTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=+NfMvoXi; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=q5Vl7/pN; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="+NfMvoXi";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="q5Vl7/pN"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1746719607; h=date : from : to : cc : subject : message-id :
 references : mime-version : content-type : content-transfer-encoding :
 in-reply-to : from; bh=FLWTV1Ar39Qb82N0ApHsxqaRxvr1SJdv0TrX1S8C/tY=;
 b=+NfMvoXilOtUREdPx2C+iq3doUh4tCNM2+t68F30voy7BPYz56Krpz94yXt8e8xBugJxl
 hxapdpgZJ2jnfHGCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1746719607; h=date :
 from : to : cc : subject : message-id : references : mime-version :
 content-type : content-transfer-encoding : in-reply-to : from;
 bh=FLWTV1Ar39Qb82N0ApHsxqaRxvr1SJdv0TrX1S8C/tY=;
 b=q5Vl7/pNbftaOTi6OoN7syfG/uD45oSCjFDev3eC/aVUjIqxFixVgR1fUVxDZdhDd477L
 aUF2CokW7wdIeLTWhwSgDLxJkWy48NIcwv3wHLn00ibe0QeKrIo5gFTtz0qhZFtqaCyevw+
 d1Wv8vfNVZIrIhpiMJmF8N4ufYUrn79Y3aUnz+yZMvmw6ZMKpjWif09ggfgznUkbE7hADN6
 Cwae0/nFNc+fPnspZoV6miR55aSoRPA6FT+y2UYurolpJ8ioR8eQ2GjLb+b2l5gNv51bvtf
 JS1dIROYINErnoaP0t1dtIIPhuWRMx1SuBHa5ZFpsFha7scWpfxTyjiYfdcQ==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature ED25519)
	(Client CN "otters", Issuer "otters" (not verified))
	by o-chul.darkrain42.org (Postfix) with ESMTPS id 8D2A18545;
	Thu,  8 May 2025 08:53:27 -0700 (PDT)
Received: by redcloak.home.arpa (Postfix, from userid 1000)
	id 9448B48052F; Thu, 08 May 2025 08:53:26 -0700 (PDT)
Date: Thu, 8 May 2025 08:53:26 -0700
From: Paul Aurich <paul@darkrain42.org>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, ematsumiya@suse.de,
	sfrench@samba.org, smfrench@gmail.com, pc@manguebit.com,
	ronniesahlberg@gmail.com, sprasad@microsoft.com,
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: avoid dentry leak by not overwriting
 cfid->dentry
Message-ID: <aBzTdkkKDyW29M9-@redcloak.home.arpa>
Mail-Followup-To: Shyam Prasad N <nspmangalore@gmail.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>, ematsumiya@suse.de,
	sfrench@samba.org, smfrench@gmail.com, pc@manguebit.com,
	ronniesahlberg@gmail.com, sprasad@microsoft.com,
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org
References: <20250506223156.121141-1-henrique.carvalho@suse.com>
 <aBr6zohhW9Akuu3a@redcloak.home.arpa>
 <CANT5p=pHLh-8fDbJ2OCdNa_eHR5T=BVJAOSYy4zs_Lk6FzR9=A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANT5p=pHLh-8fDbJ2OCdNa_eHR5T=BVJAOSYy4zs_Lk6FzR9=A@mail.gmail.com>

On 2025-05-08 20:54:34 +0530, Shyam Prasad N wrote:
>On Wed, May 7, 2025 at 11:56 AM Paul Aurich <paul@darkrain42.org> wrote:
>>
>> On 2025-05-06 19:31:56 -0300, Henrique Carvalho wrote:
>> >A race, likely between lease break and open, can cause cfid->dentry to
>> >be valid when open_cached_dir() tries to set it again. This overwrites
>> >the old dentry without dput(), leaking it.
>> >
>> >Skip assignment if cfid->dentry is already set.
>> >
>> >Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>> >---
>> > fs/smb/client/cached_dir.c | 23 +++++++++++++++--------
>> > 1 file changed, 15 insertions(+), 8 deletions(-)
>> >
>> >diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>> >index 43228ec2424d..8c1f00a3fc29 100644
>> >--- a/fs/smb/client/cached_dir.c
>> >+++ b/fs/smb/client/cached_dir.c
>> >@@ -219,16 +219,23 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>> >               goto out;
>> >       }
>> >
>> >-      if (!npath[0]) {
>> >-              dentry = dget(cifs_sb->root);
>> >-      } else {
>> >-              dentry = path_to_dentry(cifs_sb, npath);
>> >-              if (IS_ERR(dentry)) {
>> >-                      rc = -ENOENT;
>> >-                      goto out;
>> >+      /*
>> >+       * BB: cfid->dentry should be NULL here; if not, we're likely racing with
>> >+       * a lease break. This is a temporary workaround to avoid overwriting
>> >+       * a valid dentry. Needs proper fix.
>> >+       */
>>
>> Ah ha. I think this is trying to address the same race as Shyam's 'cifs: do
>> not return an invalidated cfid' [1].
>
>
>Hi Paul,
>Yes. One of my patch did this check to avoid leaking dentry.
>However, without serializing threads in this codepath, it is not
>possible to rule out all such races.
>
>>
>> What about modifying open_cached_dir to hold cfid_list_lock across the call to
>> find_or_create_cached_dir through where it tests for validity, and then
>> dropping the locking in find_or_create_cached_dir itself (see attached in case
>> my text description isn't clear)?
>
>We can do that. But holding a spinlock till the response comes back
>from the server is not a good idea.
>We could see high CPU utilization if response from the server takes longer.
>My other patch introduced a mutex just for this purpose.

I don't think my proposed patch extends locking over server-side 
communication or anything that can sleep/preempt. (To be clear about 'tests 
for validity', I just meant the 'if (cfid->has_lease && cfid->time)' test that 
occurs a few lines below the call to find_or_create_cached_dir)

Without my patch (i.e. before changes), find_or_create_cached_dir() holds 
cfid_list_lock over its entire execution, but drops the lock before returning.  
open_cached_dir() (the only caller of find_or_create_cached_dir) then the 
spinlock again and checks if the cfid is valid.

The fix just moves the locking out of find_or_create_cached_dir() so it's 
acquired _once_ and held across both searching for (or constructing a new) 
cfid and then checking the results.

I don't think there are any intervening operations that would sleep?

@@ -185,21 +178,22 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
  
  	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
  	if (!utf16_path)
  		return -ENOMEM;
  
+	spin_lock(&cfids->cfid_list_lock);
  	cfid = find_or_create_cached_dir(cfids, path, lookup_only, tcon->max_cached_dirs);
  	if (cfid == NULL) {
+		spin_unlock(&cfids->cfid_list_lock);
  		kfree(utf16_path);
  		return -ENOENT;
  	}
  	/*
  	 * Return cached fid if it is valid (has a lease and has a time).
  	 * Otherwise, it is either a new entry or laundromat worker removed it
  	 * from @cfids->entries.  Caller will put last reference if the latter.
  	 */
-	spin_lock(&cfids->cfid_list_lock);
  	if (cfid->has_lease && cfid->time) {
  		spin_unlock(&cfids->cfid_list_lock);
  		*ret_cfid = cfid;
  		kfree(utf16_path);
  		return 0;


Full patch:
https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commitdiff;h=3ca02e63edccb78ef3659bebc68579c7224a6ca2

>
>>
>> That's the only way I can see that a pre-existing cfid could escape to the
>> rest of open_cached_dir. I think.
>>
>> ~Paul
>>
>> [1] https://lore.kernel.org/linux-cifs/20250502051517.10449-2-sprasad@microsoft.com/T/#u
>>
>> >+      if (!cfid->dentry) {
>> >+              if (!npath[0]) {
>> >+                      dentry = dget(cifs_sb->root);
>> >+              } else {
>> >+                      dentry = path_to_dentry(cifs_sb, npath);
>> >+                      if (IS_ERR(dentry)) {
>> >+                              rc = -ENOENT;
>> >+                              goto out;
>> >+                      }
>> >               }
>> >+              cfid->dentry = dentry;
>> >       }
>> >-      cfid->dentry = dentry;
>> >       cfid->tcon = tcon;
>> >
>> >       /*
>> >--
>> >2.47.0
>
>-- 
>Regards,
>Shyam

-- 
~Paul

