Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5A31BB6BC
	for <linux-cifs@vger.kernel.org>; Thu, 30 Jan 2025 14:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738248231; cv=none; b=qL+lLgu7jVUYa7zTWxXXMmaN1POGPnxKfBo4QAuGcRya5i6hkkrnT1snjGZc7Ru617V9ne3H0NltrZ9/YGCTZERV52jGi8Zt3IvLEHXQrOE/WOSj4hatPaPTsIaJU4ixj0eoACJriHvGtjop5q1nRuEDqUrb6PNftudz4j2rAkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738248231; c=relaxed/simple;
	bh=UeIsAiwwTN/Rsk8k3BZ/8+xcNtjXSrKgf8pAyMMnNuE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=DVGtxX1u0671gXJUEW7KKEwUsz+zBfF5dL2o5McP/XAHMu8gq55QcuxNYIsvci47ANSiuk4G5Il03onZP7VzSaUrQ5e9cmRVRK26FHSkfICm6HqzWW/crnp2i1th+e9fnD0VPSDgYSgzqwKSNYi+Z99biqjsSkpk2Ln62zA2QUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZHaSb/ks; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZHaSb/ks"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2ee46851b5eso1162907a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jan 2025 06:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738248229; x=1738853029; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FojObKZNveW6yLw1laomnuD8py9ef6t+zzTVXe/2GBA=;
        b=ZHaSb/kspOabFI5Ik9E6jsW1KyOs3PPRJArQe1HrotobAlZlS2Juv06fjIjB8PQdqJ
         sGpoLgO1Z6ecumxLCYlnF1sWff19dOfMjTYXOZtwtBWxoUaaId7J+qPrdBC1q0CmBXoM
         nt1t+iRVEAvetxI9mGOt477nBwBZgRurLGhz/VdYMoGCjINlKi4dUkU6hXN27SdgBoag
         BxEAvgV1yWiVMUtFKU978B/Ea6aTxSA4SwJ1o/gZVkug/nINUPNAUHCETiqTEGAFEmX2
         jlllWznHPoqSGpG+B96jI/tLMZhqB3o8So4/P9kunCL8E3gDSruXFDv7IQ2LvrbLkqMn
         eL6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738248229; x=1738853029;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FojObKZNveW6yLw1laomnuD8py9ef6t+zzTVXe/2GBA=;
        b=tkOYKZtO7pWipDQoSUG1tLnH7jrNu6MYfWY+uqT++SJf06P3/85MeFBpZJJnDN0RS0
         C2ef75m0eNiewLCogb4oWK0UsEe+84MImz6EKQ76itFkJjw7o6cRdKsPVSFo3Nu6U96j
         S9D60qW1L5/P3EAa4SCax3sF4W04+fu2MgOo+9r89KXCowog8WJ2eYhPgNHSC3Fj6p/e
         Qa7DShBAwkQQ5a351Vn54r2JO6LW0CBBlZ1uTMbiW6JNYXKQOePmzV/fBqfZ9c2g9Zja
         jly48tyadZdyrk3I2h4XbPvdC2AJrYjhCpBUM5Ym4IRE/YvZNCk6aHmyPqRcDnBVVQyu
         isMw==
X-Gm-Message-State: AOJu0YysTczhe48+pkhtVnesV5h3LbRKVTPgjb7W/y3RDE2kuRDZUlKe
	dMCJwc0HJMX8Semuz4DRm61r8ahg2ZCpKHjEvfiLRVkxGuIo51uxXCv0w0+rclpHeMHyh3NvOT2
	KLQgL0SdAQYtloZHhzpgyGHQSAb9KFQ==
X-Gm-Gg: ASbGnctYJxs0a8uvZFLT5s4JRBfXLbXQ4MiFQLm1XsscWGDSJ2lsR4HJjy/K5H81bCr
	pYyV3VoEYtHo3DB04ufnS7bC1O+soO7JAyVxP4B6/E5lBmGjdxs8Ogp62NePxsCqWueKWsDb5BT
	fLludYcQ1qa8TkRkfxYp/azYZwnAE=
X-Google-Smtp-Source: AGHT+IEw3jR6GrXXmbvA+HFqTBsNKI0BQQ30/ga0HBWLDrMn/UT9GCv6rDccWKNJW/wdDl0jHrfKp+qZ0Q9UybC4GoA=
X-Received: by 2002:a17:90b:2c84:b0:2f6:d266:f462 with SMTP id
 98e67ed59e1d1-2f83ac83eadmr10871386a91.35.1738248229201; Thu, 30 Jan 2025
 06:43:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Ritvik Budhiraja <budhirajaritviksmb@gmail.com>
Date: Thu, 30 Jan 2025 06:43:37 -0800
X-Gm-Features: AWEUYZn8xw2vgPaaVS3PJ8f2yq0QKMqrx745ee1oGkfgMsPIl_R2juEIZOmwugU
Message-ID: <CA+EPQ647ii+vEbiaYT5dQXn__t2KEVypKyfsovbrwCrBQcTZow@mail.gmail.com>
Subject: [PATCH] cifs-utils: add documentation for upcall_target
To: linux-cifs@vger.kernel.org, Shyam Prasad <nspmangalore@gmail.com>, 
	Bharath SM <bharathsm.hsk@gmail.com>
Content-Type: text/plain; charset="UTF-8"

From: Ritvik Budhiraja <rbudhiraja@microsoft.com>

Update man page with documentation for upcal_target
mount parameter.

Signed-off-by: Ritvik Budhiraja <rbudhiraja@microsoft.com>
---
 mount.cifs.rst | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mount.cifs.rst b/mount.cifs.rst
index 67c5138..631482d 100644
--- a/mount.cifs.rst
+++ b/mount.cifs.rst
@@ -636,6 +636,21 @@ acdirmax=arg
   If this option is not specified, then acdirmax value will be set to
``actimeo``
   value, see ``actimeo`` for more details.

+upcall_target=arg
+  Determines the namespace in which upcalls from the SMB filesystem
should be handled.
+  Allowed values are:
+  - ``mount`` - Resolve upcalls to the host namespace.
+  - ``app`` - Resolve upcalls in the namespace of the calling thread
(application).
+  Default value is ``app``.
+  This option is useful in environments like Kubernetes, where the mount
+  may be performed by a driver pod on behalf of an application running
+  in a separate container. It ensures that Kerberos credentials and other
+  user-specific data are accessed in the correct namespace.
+  By specifying ``app``, upcalls can be resolved in the application's
namespace,
+  ensuring the correct credentials are used. ``mount`` allows resolution in the
+  host namespace, which may be necessary when credentials or configurations
+  are managed outside the container.
+
 multichannel
   This option enables multichannel feature. Multichannel is an SMB3 protocol
   feature that allows client to establish multiple transport connections to an
--
2.43.0
