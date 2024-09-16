Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030047BB15
	for <linux-cifs@vger.kernel.org>; Mon, 16 Sep 2024 13:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726494219; cv=none; b=m1xSDZWFEeGATlXfaF4gk0a3LOWFfXlPlTyCBaNKomg2rqnU3Xeya38k2bHAbO954Nxj5U5cxKREZFIQHc0uz1XG8Amc4jhRoiK7S83a7Ve5c4eX6SqDGHvE9nhaEGTXGQujyYlF5DtNcqRSpAsByhX60uhe08yNv0mqtrFvGfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726494219; c=relaxed/simple;
	bh=804IJk9+SKcpOk0SBW7w1PBINGjYMRAnV93CFUNESjg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=KtChQOCIOyZtICy8NQeAXg2lWIJdj/vdHaCcwrT1OSQzqUdk83gLwXbpJzQzqBxY+vP5qyuWFboj0tT7qGSuHIHN0N9RtQCsNUBJbJ/kVyCYXHfLaw/p6rxHdhaOgQOhUS154CP7Z6B2uq6DpYwaY1ahMKSd0e9LcQdrfOEyNyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N5lRcGGl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N5lRcGGl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726494217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=804IJk9+SKcpOk0SBW7w1PBINGjYMRAnV93CFUNESjg=;
	b=N5lRcGGlNOZlEY9ck1qwbJCWEN/4+TLPJz+YjUvZokJVxIoUhkyp3oIN+exNQdKXcE0jOm
	tSxD0sxeLSoULJJhSuQEK6ogy8zHcYPoTBh0HU+Ox5sP8FKxWX+GkDZdnrohrIJTxMMak7
	NZTyo6eQndbkAceKRk5xwm2m9BhGCS0=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-NdYqZPNaPGivuHGR8jIusw-1; Mon, 16 Sep 2024 09:43:35 -0400
X-MC-Unique: NdYqZPNaPGivuHGR8jIusw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-536800baa8aso2746880e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 16 Sep 2024 06:43:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726494214; x=1727099014;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=804IJk9+SKcpOk0SBW7w1PBINGjYMRAnV93CFUNESjg=;
        b=gMDpjKdQii/e0JLftHeIh3tOgpsKqAQKl70q6OnxxrOleGr1zmGX43bLQhLOMvQ8J+
         7f4d8kuZl0G+2ug6x73bu19YL4HwUEun8Yu047OoyadiQtl0vfpEZH05rYBVMNot79rg
         GeMNhXkHDfuu+fW3JlSki9vqEZWtg1pVKsJPPVM26rNrca+1qwMxiw6E/rlYOisFOT+3
         CAFjxI2xs++rlpqykd8K90ViCEF8vVgJ/xGaSD8TxY+1BszWKie3VKEtz3a0q0UXxAgP
         E4griAtnyO7J1Wdxcb2/EDtixvjtO1Tnh24Xtf/vyWYfSmNdX7WF+o0o9FajxVU4t8NB
         wPeA==
X-Gm-Message-State: AOJu0Yw0JbPuN7r8Z+0yEUb2aQlZ1rTDLHrhozU4CcvkOFQDUBURJcQX
	dC6Wl/PU6yo/UCxkap4pVTTlxdNowQ2zuFmwbBDPqFB+llUbiD+zzTpdNIzlLIt1xCObSf3uijW
	K1CPqOY6yg0lfZzlfhu4UN/8iIve/at+UO99YZns43CIxgO7shCZZbt0G8ZaShi3w8kKfgYIvc1
	BhYRtDWpqW6DsbhAHxTSf6UIX9koTsw4I2UUOiaixEBw1U0O8=
X-Received: by 2002:a05:6512:3e02:b0:536:569b:a59c with SMTP id 2adb3069b0e04-53678fb1ed6mr8202552e87.4.1726494213908;
        Mon, 16 Sep 2024 06:43:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJBM0pQf1m28WFGuv1QMv7FpJyfVr5aWggNDLSoqEiRKy8EQ6rMX16HKDFBSzvVqGHnfOy9oWeTBP9/LHP9yM=
X-Received: by 2002:a05:6512:3e02:b0:536:569b:a59c with SMTP id
 2adb3069b0e04-53678fb1ed6mr8202502e87.4.1726494213032; Mon, 16 Sep 2024
 06:43:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Maxim Patlasov <mpatlaso@redhat.com>
Date: Mon, 16 Sep 2024 15:43:22 +0200
Message-ID: <CAKRryJZs-gXnWCYUXhbjV__OM7T85xpKp9nvPOprJzcOJGX9=A@mail.gmail.com>
Subject: rmdir() fails for a dir w/o write perm
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Is this a bug or well-known issue?

# mount -t cifs -o
dir_mode=0777,file_mode=0777,username=jane,password=pass,vers=3.1.1,addr=127.0.0.1,uid=0,gid=0,noperm
//127.0.0.1/share /mnt

# mkdir /mnt/dir
# chmod a-w /mnt/dir
# rmdir /mnt/dir
rmdir: failed to remove '/mnt/dir': Permission denied

Thanks,
Maxim

