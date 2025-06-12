Received: from o-chul.darkrain42.org (o-chul.darkrain42.org [74.207.241.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990FB2222A6
	for <linux-cifs@vger.kernel.org>; Thu, 12 Jun 2025 16:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.207.241.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749746009; cv=none; b=uzep2b4FHI+H3j4+fCu929mrmUjszzS4x6DPx17VqBha5VlVB135IwqcnqAS2gJ/J8zEP6QdpD/agXWwxgc6SQYG6NRFGK0xApc7XREP4NCPXd7Cb+yrhzCIc+38ev8OVJlNloUwmz62AYgV2PTuOsC5bblCAsTElyBgLkYUraQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749746009; c=relaxed/simple;
	bh=MQg3IBjs4r/gsXhQispUCCvpn9lgpMjgrQhqv4JwyFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rlflAsFc8b9/NgdgFrHiLn5y/FKaJxaueMngBkX7yWEcKsaSSxtjJSfwGci6BBZbonlUYth2+E2Cjemz4YVBhhPPKyXr9fTqlPZyKxE2ga3uC+bwSNdL6FI9DCGl/z8ywv0pTstiOEzMB0KY2IlNQkdMAmhhnewJX++Vs7g1uaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org; spf=pass smtp.mailfrom=darkrain42.org; dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=UqQs0Xli; dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b=cIRM8zhm; arc=none smtp.client-ip=74.207.241.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darkrain42.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="UqQs0Xli";
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="cIRM8zhm"
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2022-03;
 t=1749746006; h=date : from : to : cc : subject : message-id :
 references : mime-version : content-type : content-transfer-encoding :
 in-reply-to : from; bh=t8sv7zJ6SmhI0iL7ToCBzKP/dYrg2KLS02wNS88rS9M=;
 b=UqQs0XligkUOObKMarwRjV2GR4BAJ2pfgM6Y+LIbK8/m2qJ2LS/7hMmcc3VtOtaZy+7aD
 G2nKFt1n01HZ8ONBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2022-03; t=1749746006; h=date :
 from : to : cc : subject : message-id : references : mime-version :
 content-type : content-transfer-encoding : in-reply-to : from;
 bh=t8sv7zJ6SmhI0iL7ToCBzKP/dYrg2KLS02wNS88rS9M=;
 b=cIRM8zhm5ZeiiQkTogVQSfiop9tFtBsUDXu3VgQkFmxXxTui31B1YjKgfKnggj0tKD8tu
 TYL7XcFjuWrmh9chUm0nJkJ52EbvTGIuVg02sHbyAxm0GKflvTFRUJNpJZ7LAhem2NDzHXZ
 tcgHtuoMcW0d+KUNgDJ6VCbw4qF7JYJnQ8oguCIeleBqfCOicxPY9RiP8dsTfr8I6slnRK/
 J8qL6r4sarO5u+btq0tBxW7INnVy8YnE+lj0TJxpuF16Grxp7dKrp9AGqfVt5mYTAc4Wz1Z
 2pMNCxv5ZJTfnIwN2KVs3oF+8dLq2Nc9i7R3IVQwHsGCVecQtk2q+ciLcvhQ==
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256
	 client-signature ED25519)
	(Client CN "otters", Issuer "otters" (not verified))
	by o-chul.darkrain42.org (Postfix) with ESMTPS id C37E68186;
	Thu, 12 Jun 2025 09:33:26 -0700 (PDT)
Received: by redcloak.home.arpa (Postfix, from userid 1000)
	id A5DE7480AD0; Thu, 12 Jun 2025 09:33:20 -0700 (PDT)
Date: Thu, 12 Jun 2025 09:33:20 -0700
From: Paul Aurich <paul@darkrain42.org>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com, pc@manguebit.com,
	henrique.carvalho@suse.com, ematsumiya@suse.de,
	Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 2/7] cifs: protect cfid accesses with fid_lock
Message-ID: <aEsBUL0c4wuErOjc@redcloak.home.arpa>
Mail-Followup-To: Shyam Prasad N <nspmangalore@gmail.com>,
	linux-cifs@vger.kernel.org, smfrench@gmail.com,
	bharathsm.hsk@gmail.com, meetakshisetiyaoss@gmail.com,
	pc@manguebit.com, henrique.carvalho@suse.com, ematsumiya@suse.de,
	Shyam Prasad N <sprasad@microsoft.com>
References: <20250604101829.832577-1-sprasad@microsoft.com>
 <20250604101829.832577-2-sprasad@microsoft.com>
 <aEpIiybxbTbIbDBP@vaarsuvius.home.arpa>
 <CANT5p=oV8SoYT9AWBCBU5uVFaboeWFyGw8jj9rckLn1eyOj3Cg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANT5p=oV8SoYT9AWBCBU5uVFaboeWFyGw8jj9rckLn1eyOj3Cg@mail.gmail.com>

On 2025-06-12 18:35:13 +0530, Shyam Prasad N wrote:
>On Thu, Jun 12, 2025 at 8:55 AM Paul Aurich <paul@darkrain42.org> wrote:
>>
>> On 2025-06-04 15:48:11 +0530, nspmangalore@gmail.com wrote:
>> >From: Shyam Prasad N <sprasad@microsoft.com>
>> >
>> >@@ -220,17 +225,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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
>> >-              }
>> >-      }
>> >-      cfid->dentry = dentry;
>> >-      cfid->tcon = tcon;
>>
>> I think moving this down below to after the "At this point the directory
>> handle is fully cached" comment is going to regress c353ee4fb119 ("smb:
>> Initialize cfid->tcon before performing network ops").
>
>Hi Paul,
>
>Are you referring to the tcon reference?
>If so, I think the way to fix that is to get a reference (tc_count++)
>on tcon right when we add it to the cfid->tcon, and put the reference
>in smb2_close_cached_fid.
>I think that should take care of any concerns of race. Let me know if
>you disagree.

I don't think that is sufficient.  cfid->tcon needs to be initialized prior to 
the network operations in open_cached_dir.  If we receive a lease break from 
the server and the delayed work involved in that runs *before* cfid->tcon is 
initialized, it leaks a ref.  (cached_dir_lease_break has a direct copy of the 
tcon passed as an arg and takes a ref from that, but cfid->tcon is still NULL)

T1                 T2

open_cached_dir
   <open+lease acquisition>
   (gets far enough along that the file is open and lease key initialized)

                    // receives a lease break from the server
                    cached_dir_lease_break
                      // takes a ref on tcon (via arg to function, not cfid->tcon)
                    cached_dir_put_work
                    cached_dir_offload_close
                      // cifs_put_tcon on cfid->tcon, which is still NULL

open_cached_dir continues on at this point

Another reason you need to initialize cfid->tcon earlier is that in the error 
paths, cfid->tcon needs to be valid so that smb2_close_cached_fid can actually 
close it.  Before c353ee4fb119, the tcon was initialized at the same time 
cfid->is_open was set.

>>
>> >       /*
>> >        * We do not hold the lock for the open because in case
>> >@@ -302,9 +296,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>> >               }
>> >               goto oshr_free;
>> >       }
>> >-      cfid->is_open = true;
>>
>> Moving this down below is going to regress part of 66d45ca1350a ("cifs: Check
>> the lease context if we actually got a lease"), I think. If parsing the lease
>> fails, the cfid is disposed, but since `is_open` is false, the code won't call
>> SMB2_close.
>
>That's a good point. I'll submit a patch to fix this.
>

>-- 
>Regards,
>Shyam

-- 
~Paul

