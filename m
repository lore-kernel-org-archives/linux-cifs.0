Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEC41C5D4E
	for <linux-cifs@vger.kernel.org>; Wed,  7 May 2025 06:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746599210; cv=none; b=cN7uxGKUinsvlm4a72HVQGOq9ujfWBSPsPe1/E9YzVnkLBvXQpLI0TK4rIsU395BOH733FWggpRK4tovBP90iLBqQdL0iCzXt5TmWlKUWTpIsBKbCmsuKN/C2v4XMVCP7Zkwl80mjZhQWX+EUUkU8/AOhlWq2et9/RCI0Tdcfr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746599210; c=relaxed/simple;
	bh=y2lvlJquSQ9Bik1qnt6p/fPMKc3KJSAZ5G9Xvk3+GhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZlDfOAxcwh9eMrx+yqd1zAfVFEBIpqURL93BNQcA8Uafmi3K3wZtoi4sisaj5coPtZG+qPukQrfDLgPGzWyh2CxtVl4MB8vluLOoS7gfv++whcS8dMdwZVid8IupxMnHjkirhZNsdqPAWsbuojoS0EnxmKyYi89eLMPZ+icwpLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=ZlKVE02F; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=GlES9QTP; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="ZlKVE02F";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="GlES9QTP"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1746598607; h=date : from : to : cc : subject : message-id :
 references : mime-version : content-type : in-reply-to : from;
 bh=e5Ljc9bo8PYzsVkNIFnnecYx8+hu31KSBRVLZfnHFWk=;
 b=ZlKVE02FkqI3so4sYwSWKdxids+sIt5dk/Mxep35x5XXvpwqS3Ag7h5e7qGulRrWqLc8n
 bjI/aXXV1S8O1c1Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1746598607; h=date :
 from : to : cc : subject : message-id : references : mime-version :
 content-type : in-reply-to : from;
 bh=e5Ljc9bo8PYzsVkNIFnnecYx8+hu31KSBRVLZfnHFWk=;
 b=GlES9QTPnUT7FOTBSVL5GiY7miwkbjyrgkF4GfXBr3+lAhzBEz689Vnkd5SSCzCfmGQI3
 2D2Vk+LR0avwvCoR0VWMKlhb+0xgwvyue1xQoFLxc5jpY/fKhG/5w5uy/3tic7LMplR3TKA
 gAsWbX9AtI9xPit3lj8H6lgtKRF+8BWWufEDalVm+6BzNV4FqG8YEhban8S3/vmi9xwFRyP
 4Z/x4kXp0P7/lGqv1XTJIeCz39+QVt9S/+oK1tRJZGYeq/ga8vT/ZauOSOP7bkDIxzlS7Y/
 CJpCjbeNZc7MWj2xXrnLMG4nUdEXVjCo4sXV9VfBgpNV6LJ1QfxaI7TSuFxg==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
	 client-signature ED25519)
	(Client CN "otters", Issuer "otters" (not verified))
	by o-chul.darkrain42.org (Postfix) with ESMTPS id 1572B854D;
	Tue,  6 May 2025 23:16:47 -0700 (PDT)
Received: by redcloak.home.arpa (Postfix, from userid 1000)
	id 11287480B42; Tue, 06 May 2025 23:16:46 -0700 (PDT)
Date: Tue, 6 May 2025 23:16:46 -0700
From: Paul Aurich <paul@darkrain42.org>
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: ematsumiya@suse.de, sfrench@samba.org, smfrench@gmail.com,
	pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com,
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: avoid dentry leak by not overwriting
 cfid->dentry
Message-ID: <aBr6zohhW9Akuu3a@redcloak.home.arpa>
Mail-Followup-To: Henrique Carvalho <henrique.carvalho@suse.com>,
	ematsumiya@suse.de, sfrench@samba.org, smfrench@gmail.com,
	pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com,
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org
References: <20250506223156.121141-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="kbpI8/AObxx6K3ox"
Content-Disposition: inline
In-Reply-To: <20250506223156.121141-1-henrique.carvalho@suse.com>


--kbpI8/AObxx6K3ox
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 2025-05-06 19:31:56 -0300, Henrique Carvalho wrote:
>A race, likely between lease break and open, can cause cfid->dentry to
>be valid when open_cached_dir() tries to set it again. This overwrites
>the old dentry without dput(), leaking it.
>
>Skip assignment if cfid->dentry is already set.
>
>Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
>---
> fs/smb/client/cached_dir.c | 23 +++++++++++++++--------
> 1 file changed, 15 insertions(+), 8 deletions(-)
>
>diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
>index 43228ec2424d..8c1f00a3fc29 100644
>--- a/fs/smb/client/cached_dir.c
>+++ b/fs/smb/client/cached_dir.c
>@@ -219,16 +219,23 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
> 		goto out;
> 	}
>
>-	if (!npath[0]) {
>-		dentry = dget(cifs_sb->root);
>-	} else {
>-		dentry = path_to_dentry(cifs_sb, npath);
>-		if (IS_ERR(dentry)) {
>-			rc = -ENOENT;
>-			goto out;
>+	/*
>+	 * BB: cfid->dentry should be NULL here; if not, we're likely racing with
>+	 * a lease break. This is a temporary workaround to avoid overwriting
>+	 * a valid dentry. Needs proper fix.
>+	 */

Ah ha. I think this is trying to address the same race as Shyam's 'cifs: do 
not return an invalidated cfid' [1].

What about modifying open_cached_dir to hold cfid_list_lock across the call to 
find_or_create_cached_dir through where it tests for validity, and then 
dropping the locking in find_or_create_cached_dir itself (see attached in case 
my text description isn't clear)?

That's the only way I can see that a pre-existing cfid could escape to the 
rest of open_cached_dir. I think.

~Paul

[1] https://lore.kernel.org/linux-cifs/20250502051517.10449-2-sprasad@microsoft.com/T/#u

>+	if (!cfid->dentry) {
>+		if (!npath[0]) {
>+			dentry = dget(cifs_sb->root);
>+		} else {
>+			dentry = path_to_dentry(cifs_sb, npath);
>+			if (IS_ERR(dentry)) {
>+				rc = -ENOENT;
>+				goto out;
>+			}
> 		}
>+		cfid->dentry = dentry;
> 	}
>-	cfid->dentry = dentry;
> 	cfid->tcon = tcon;
>
> 	/*
>-- 
>2.47.0

--kbpI8/AObxx6K3ox
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-smb-client-Avoid-race-in-open_cached_dir-with-lease-.patch"

>From 583824153dd901f1f7d63ce9364d32c9c249fd43 Mon Sep 17 00:00:00 2001
From: Paul Aurich <paul@darkrain42.org>
Date: Tue, 6 May 2025 22:28:09 -0700
Subject: [PATCH] smb: client: Avoid race in open_cached_dir with lease breaks

A pre-existing valid cfid returned from find_or_create_cached_dir might
race with a lease break, meaning open_cached_dir doesn't consider it
valid, and thinks it's newly-constructed. This leaks a dentry reference
if the allocation occurs before the queued lease break work runs.

Avoid the race by extending holding the cfid_list_lock across
find_or_create_cached_dir and when the result is checked.

Signed-off-by: Paul Aurich <paul@darkrain42.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/cached_dir.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 10aad87ce679..cb8477c18905 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -27,38 +27,32 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 						    bool lookup_only,
 						    __u32 max_cached_dirs)
 {
 	struct cached_fid *cfid;
 
-	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
 		if (!strcmp(cfid->path, path)) {
 			/*
 			 * If it doesn't have a lease it is either not yet
 			 * fully cached or it may be in the process of
 			 * being deleted due to a lease break.
 			 */
 			if (!cfid->time || !cfid->has_lease) {
-				spin_unlock(&cfids->cfid_list_lock);
 				return NULL;
 			}
 			kref_get(&cfid->refcount);
-			spin_unlock(&cfids->cfid_list_lock);
 			return cfid;
 		}
 	}
 	if (lookup_only) {
-		spin_unlock(&cfids->cfid_list_lock);
 		return NULL;
 	}
 	if (cfids->num_entries >= max_cached_dirs) {
-		spin_unlock(&cfids->cfid_list_lock);
 		return NULL;
 	}
 	cfid = init_cached_dir(path);
 	if (cfid == NULL) {
-		spin_unlock(&cfids->cfid_list_lock);
 		return NULL;
 	}
 	cfid->cfids = cfids;
 	cfids->num_entries++;
 	list_add(&cfid->entry, &cfids->entries);
@@ -72,11 +66,10 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 	 * Concurrent processes won't be to use it yet due to @cfid->time being
 	 * zero.
 	 */
 	cfid->has_lease = true;
 
-	spin_unlock(&cfids->cfid_list_lock);
 	return cfid;
 }
 
 static struct dentry *
 path_to_dentry(struct cifs_sb_info *cifs_sb, const char *path)
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
-- 
2.47.2


--kbpI8/AObxx6K3ox--

