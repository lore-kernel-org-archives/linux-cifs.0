Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889AD35E922
	for <linux-cifs@vger.kernel.org>; Thu, 27 Aug 2026 01:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787795474; cv=none; b=ozPJm4Oi9uWEWVZR4Q1/fCJD9xaO2F1JLGQBmubFV89ia+OztbYvj5Mg5GzuftzpAEgpaTqmWbvalpJZz8pCu3R1E7kpDCroh2iOc3X06R/S2hotX8BQZRWvongjVOm6RAn3A6JGm7a+4l5oo1JwHqLwA1DiKFM+WrO29Mhrx3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787795474; c=relaxed/simple;
	bh=/5GHCPus8JVlsvmowqfGpvtY6DSST+HPkaDvTH4uhqQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m15jtf0CMoiXo+zO6jIbLd4lGDiTzTc+kjhqsXos1VM8/D7HJ3ewIPIXxd1rw1dsK1Wy8ujWt+bKa7up+b6fTJuvUYxQDDNrHKvXF4AhY84Uts7n70W0CPNWMTThArEFTgHKUflnUg5Tkrq/U/4ZqbtQcvx8JZELeusrdN/E8F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VZkovH8C; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gEXYq82T; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VZkovH8C";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gEXYq82T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787795471;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kwxQPCUC62n4A4jll7ISGwOMXeXpaSPMOhiI9Bk5Ugg=;
	b=VZkovH8CuGJ1YSrBTC1wh/a/bxPg8PV2d6JI0+BNEPAKgRnNaqCUO+NmOhN/u/RGuwkNai
	brjy3OY8IEqGZuTsJF50l145CqbPXf4d4j4OwQwsuogHX/EU35acrhKL7zULLkvPILHZ66
	YL9mVAo1a2/aXmCTTDoiUpzWKScegPc=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-AKHBPdVyM66BeKXwqflofw-1; Wed, 26 Aug 2026 21:51:10 -0400
X-MC-Unique: AKHBPdVyM66BeKXwqflofw-1
X-Mimecast-MFC-AGG-ID: AKHBPdVyM66BeKXwqflofw_1787795469
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-52f9e903b02so3758031cf.0
        for <linux-cifs@vger.kernel.org>; Wed, 26 Aug 2026 18:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787795469; x=1788400269; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kwxQPCUC62n4A4jll7ISGwOMXeXpaSPMOhiI9Bk5Ugg=;
        b=gEXYq82To9sa7jRSE+n+sTjgH+Tlcz05ZAHysjKjbLwQf+qc92mj7ClUtgjIrn0BhH
         2F+ecVxpRvAF8i05MpleaEjMsey42hVuseeYrrZb7xCns1jTQ901RF+xbZDFBNaD0FBk
         VuUyDXGx4Gd23n8zUCAg/VRw5ejYvFj+lN19NDH/0xC0YZ1LJpQqXcV8AF6Aju1rJvf8
         72EAH6eH9O8w78HvOWDmRl4kEoPNvScUPQ8tkYDj6WuXc1iJ9AqMeIBK+Oya+g05Q89V
         ZyIGSaDSrv90wv53ZeoLnQ4PJODfd3eCRxz/muig/ef0Z7/Plgw1bzFZhdffzDPvatP7
         Hpcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787795469; x=1788400269;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kwxQPCUC62n4A4jll7ISGwOMXeXpaSPMOhiI9Bk5Ugg=;
        b=qhGS4Aj9kybFFrylm/bCFsESwhwO/djV1syYYt1+JZgrL/2wBcgpH44wQy1WY2Wilr
         TpRGLj3bd3+m2bBlmGqwqgl9kPgdSxOAkicC/yiPKOiXMEtmSt8O6OMvWSU6Nth1o63J
         HtGIPaUq6aUeVjMqmsMCsoWQAp0t6WTbCQbFgHKtfQp1dbRjaGMIzY+4qc55OMFLegP4
         cMKJWE3ObHMUZ51bWhfPmbygvgk9aZhqeGfAl1YJgjLAqZw9yya1gGtI0qLJhgPWRa+5
         Otlc67WTi1HfRTUTLS6b+QFM6opq3q1aQA75gevw/YgtO2/A3yNA1AK2e4DzMvwqxP7o
         JjMw==
X-Gm-Message-State: AFuF++kb+2zxbQkXuyti7I6ioxf76OZlDZfL31LbzAABWW5tLLMhgZA1
	eUdu3PEZbJRdHGC4f4pnxJUN0d7JwzRdWSDJCoh7IoWwagFxUEVbfCkVaooJ4Uzvq1/7bWyx2dZ
	kysPBbhmsWj9MdNY/qFTR8FxuzUCzIr1XPYwMitxF+5bTOJv7vVJzakFqOrMKbZS0RfAb+nI=
X-Gm-Gg: AR+sD133N0EQUUpTruUgbxQepnuY2pngRHQLI/2MFYvrkooFIOQg3hZFzADKdRUOETt
	HnQS/Ov25m2Cbrum2/XMUykwcqIORx0CzUtSnoJHVHfXA9wIfsfrQX5Yu31zoI5J0x0LpJ1S2IN
	haAJcGxINOSwelFkfsf9LFTpVBTV5Sjy1Nx+8wF95o607eZ7ZIkPcSEnqZFbSxxIVdoNYPlpnzx
	Y32y+pPjYV2iG17VIrgTAl5F4ONnr3set8KjuMEKqR7fHOBAgis0q9i2VEWqC1FHCEIu0CahTE2
	IWajt7lRR5+lUYpygB5WG6+M5Hvu/qf6fsF26c8A5HZ7Qcvux0ewXlI6wNvc1dLNAmMbMnt4qMZ
	KknvGTapY1870o4f3GZ4qP5Df7L4dQOiqpVj/Xz0i
X-Received: by 2002:a05:622a:4d85:b0:528:ce0:e9f8 with SMTP id d75a77b69052e-52fa1a4aaa1mr39847401cf.3.1787795469384;
        Wed, 26 Aug 2026 18:51:09 -0700 (PDT)
X-Received: by 2002:a05:622a:4d85:b0:528:ce0:e9f8 with SMTP id d75a77b69052e-52fa1a4aaa1mr39847081cf.3.1787795468907;
        Wed, 26 Aug 2026 18:51:08 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cd7028aefsm4963426d6.14.2026.08.26.18.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 18:51:08 -0700 (PDT)
Message-ID: <0b126924-ff65-4db2-8aa6-2a6b8ad4290b@redhat.com>
Date: Wed, 26 Aug 2026 20:51:07 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH v4 1/2] cifs: don't update i_size in cifs_do_truncate()
 without a cached handle
To: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
References: <20260821184109.1834871-1-sorenson@redhat.com>
 <20260821184109.1834871-2-sorenson@redhat.com>
 <CAKYAXd-st8zvEiMTKw5vggFVTvY_Ln5nA3zeZgThuqQuQxAZtA@mail.gmail.com>
 <59a8b739c6b925fdc4fda0580852f91e@manguebit.org>
From: Frank Sorenson <sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <59a8b739c6b925fdc4fda0580852f91e@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 8/26/26 5:46 PM, Paulo Alcantara wrote:
> Namjae Jeon <linkinjeon@kernel.org> writes:
>
>> On Sat, Aug 22, 2026 at 3:41 AM Frank Sorenson <sorenson@redhat.com> wrote:
>>> If find_writable_file() returns NULL, cifs_file_flush() returns 0
>>> without issuing set_file_size, and the outer if (!rc) block sets i_size
>>> to 0 before the server is told to truncate.  If the subsequent
>>> cifs_open() fails, the inode is stranded at size 0 while the server
>>> file is unchanged.
>>>
>>> Move netfs_resize_file() and cifs_setsize() inside the if (cfile) arm
>>> so they only run after a successful set_file_size().  In the no-handle
>>> else branch, call truncate_inode_pages() to evict stale pages before
>>> the O_TRUNC open: cifs_invalidate_cache() is fscache-only and does not
>>> touch the VFS page cache, so without it old pages persist and may be
>>> served as stale data after a later file extension.
>>>
>>> Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
>>> Cc: stable@vger.kernel.org
>>> Cc: Paulo Alcantara <pc@manguebit.com>
>>> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
>>> ---
>>>   fs/smb/client/file.c | 18 ++++++++++++++----
>>>   1 file changed, 14 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
>>> index 389083f9ce00..05aeb9d94ffe 100644
>>> --- a/fs/smb/client/file.c
>>> +++ b/fs/smb/client/file.c
>>> @@ -1012,10 +1012,20 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
>>>                          server = tcon->ses->server;
>>>                          rc = server->ops->set_file_size(xid, tcon,
>>>                                                          cfile, 0, false);
>>> -               }
>>> -               if (!rc) {
>>> -                       netfs_resize_file(&cinode->netfs, 0, true);
>>> -                       cifs_setsize(inode, 0);
>>> +                       if (!rc) {
>>> +                               netfs_resize_file(&cinode->netfs, 0, true);
>>> +                               cifs_setsize(inode, 0);
>>> +                               cifs_invalidate_cache(inode, 0);
>>> +                       }
>>> +               } else {
>>> +                       /*
>>> +                        * No cached handle; the server truncates as part of the
>>> +                        * O_TRUNC open request that follows.  Evict stale pages
>>> +                        * from the page cache now so they cannot be served as
>>> +                        * stale data after the file is later extended; i_size is
>>> +                        * updated from the server's open response.
>>> +                        */
>>> +                       truncate_inode_pages(inode->i_mapping, 0);
>> truncate_inode_pages() expects both ->i_rwsem and ->invalidate_lock to
>> be held. Please check the comment of truncate_inode_pages().
> Frank, please resend with the expected locks held.

Sorry, I thought I had.  I will do this now.


(note: patch 2 of this series has already been taken, so I'll just 
resend v5 of this patch)


-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

