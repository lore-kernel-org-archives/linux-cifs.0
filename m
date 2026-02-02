Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C127636075F
	for <linux-cifs@vger.kernel.org>; Mon,  2 Feb 2026 15:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770046793; cv=none; b=LAgxQbi4MLS5zyGa4yYNlYADnznjaHPsNX1X1BJSLylQABzoXK4TXU9Sw9FI3Yp4ifrq9XDtg+jyugRkZQwIH8VxM9VBjalNPY2Yk7JuJE30ZosVagTyWrxrBFDscwOUU7R34AcUKOrbRwv9ekC3NqvlHj7AbFn8FSyZxYImSNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770046793; c=relaxed/simple;
	bh=aamLENBwE7SoI9BhezuE5Ct/Ovt8+yBq4LvqdRujW5Q=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=sXv40wy0nUDHmkveTyl3DYtzp2rzpysCAd3wv5DMno5/TIssUybqdBZG6jPGhG+APdbQAU28SCPS/6x0MZ8I0ePk+qAanWMLk+Yu0Z2PAI7n0uez8V2fIrYDMS2gYENCXgDEqNjlQNA0Y38wUL1rdD8jasaMAtEBi067IPbkNk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LYhJAass; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LYhJAass"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770046790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=00wSqA+oTdQaqXHeHrWAMR9XvLStUZjB8scqhHTqvVk=;
	b=LYhJAassy8IiGRTvSgU1iiwwZ9FKUgFzn8qfrr1dlpD74KOMVJkDQ4TX7vjxJNaGD7O+X3
	BPWIS0Y/UzgC+AFRxggjWCwCXJOK3SlUjEzwhzxFi0t1HYU8yFzv5ESuLK9wJJwhG2MCou
	WyUe2vHH7uuGTOKkJjshp8QmtvnIwtQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-JtvvQs32PKWHghc5_npKfg-1; Mon,
 02 Feb 2026 10:39:49 -0500
X-MC-Unique: JtvvQs32PKWHghc5_npKfg-1
X-Mimecast-MFC-AGG-ID: JtvvQs32PKWHghc5_npKfg_1770046787
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7BC8419560B2;
	Mon,  2 Feb 2026 15:39:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.164])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E84F61800577;
	Mon,  2 Feb 2026 15:39:45 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=oDUoq0JgTReUazFds5iLc+-gfiwL1iJXbeF-+YReXfSg@mail.gmail.com>
References: <CANT5p=oDUoq0JgTReUazFds5iLc+-gfiwL1iJXbeF-+YReXfSg@mail.gmail.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: dhowells@redhat.com, CIFS <linux-cifs@vger.kernel.org>,
    Steve French <smfrench@gmail.com>,
    Paulo Alcantara <pc@manguebit.org>
Subject: Re: Problem with existing SMB client mount code
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2463049.1770046784.1@warthog.procyon.org.uk>
Date: Mon, 02 Feb 2026 15:39:44 +0000
Message-ID: <2463050.1770046784@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Shyam Prasad N <nspmangalore@gmail.com> wrote:

> There's a problem that I noted with SMB client mounting code
> (cifs_smb3_do_mount). In this function, we first setup a cifs_sb, do
> the cifs_mount, and then check to see if an existing sb can be reused
> with sget. If it can be reused, we free the cifs_sb we allocated using
> cifs_umount and happily share the superblock that sget returned us. We
> leave the task of superblock maintenance completely up to VFS. The
> problem comes when we get a remount call on one of the mounts sharing
> a superblock. Today, we do not have any way to tell whether the mount
> for which the remount call has come is being shared with another
> mount. So any remount changes will reflect for all the mounts that
> share the sb. This might not be what the user intends to do.
> 
> I did a quick check of which filesystems make use of sget, and there
> are not a lot. Other than SMB client, there's ext4 that seems to use
> this for their testing, and 9p who do not provide a test function (SMB
> client provides a test function in cifs_match_super).
> 
> I think this maybe a problem for users. I propose calling sget without
> the test function, so that we do not end up sharing superblock
> instances. Please let me know your opinion on this.

The problem really is that remount is being overloaded and abused as an API -
but there's not a whole lot we can do about that.

The problem with not sharing the superblock is that you don't share any of the
caches - not pagecache, not fscache.

The question is: Why might someone want to remount?

David

