Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.181
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792543194;
	b=5mui17UMz8iYmd1GxD57m3INhHNemk9ktO217ns3V+9eJgV8u5553kXnJdzYCturhUpy
	 VYdOsCciaJfr19HP4jIyW+z6igCN+n84CB/BBujAV5wDebuP4ZdDkcs6or1CjG5A9WdyQ
	 ixK1xWRakWAH9awB4hRzlEmN//AzPVtjcw+s3xaJFaklewVC8rnpSMWnK5PhK8FH+cZcx
	 X2vkcJHy9sgtKEQkIQChRPxVfjLsXMMasQITcDcV08oM/0V06BKUZcyoAfzh/0Ywa4lI2
	 vqqSrQmBMKeMevVMhv4n5tfzastVS1KW7uFGwxS9PMCSjhAwDzRdfMslfKrTjRZb5Ug==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792543194;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=yRIGCmBCLZXrskue80uJ2gMa4RxJkt2FFdVYi0NxvFw=;
	b=FE6TotmdouP9grSm6quoy7bCVxO86AxzYwNObkAJQFUJVVyTC2Aif097eT2qM+Ocn9Da
	 dq4xYo1RuwWi1J8Xoxpf6QMjp9DsLttgl4NcLmE9cH7iEh5hY1pC5ZB4BQI2ZobqtefzS
	 wNOV3NdJuLsYj6O4rqKsWFrPcJDXm9/rQbuh1sW5JQuyf+8w54F0CeU2XgvesXTRmeUE2
	 SKkaL2USdfjALutL9CDztFjzRthvly8HqmlgwhiL9DLy/6r7t6WSASF3VEBA5c3qgg6UM
	 wHg6MT6/N2/S3qrx5+eRqBhSJAag+9PzadW+h0zF+ic4DA9dYToZUztZRQZAy0+tF/w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AA+ACyLS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.181
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CD4606A31E
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 00:39:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12CD4606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AA+ACyLS
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-5eae1276409so39248e0c.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 17:39:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792543193; cv=none;
        d=google.com; s=arc-20260327;
        b=Rc3igOu2VyYp1HncUIwpzCvB/T5Jg2miBf0VON+bH6bGdR/WXakEbL3CpjXm2Un06A
         apYc9DiBtX6pJLi9zqcFGQMlCidkXDsIg4REONJ2lU2+e3Y2b/NxW4rfzNX5l7+3+N8F
         2gRyajuVZf4Sx+FK7wgFcstT8lZbQxKbFy+h0gNCZu7L68nKdKCTrO09MydIZK6b1VTT
         dFpJsL2cSXx0naAwZGtl5xOACwlk/GIStxy8eMXFV+rwjxaJ4Vo4uQwm3ZtU+CcrJrsG
         3ftgTwC+FPdEDi8DyTXmVTrumMfTLxn1Sv4tJSSbdQ7tEUf3foAt7Y+XSpkCmFmbY5l3
         TL3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=yRIGCmBCLZXrskue80uJ2gMa4RxJkt2FFdVYi0NxvFw=;
        fh=BeDyZzmfJH/08kwnYpjYRPPSj2AqmVUYNRCu5IBQv6M=;
        b=VsZ18NqTq0gkExfcX7uW5163O3odx34LkofnqJ58nuzDDJ94Yl7RVHBB477lBcxup3
         YlOIFhCoVaifhzMvc/gBwOthcRUDY1RW6w4/ozWbkCtVjlSG0YfFmztLzU2CoG6srkb9
         pbqjMmS0jU76do1c4J2w8+DjsBElN849rVxsuyvATwT7+XWpRRhq+LG19JR30J05DZoB
         odfb14anHSKM0XIm9SuFpa5Litt1J65EFB5zpmQrfUuYib1WTJF4nD/slqhmGabVvu7w
         D2AVYUN3++tuNztMl0lDL+GbrBPQ8dwK5iY7pdJBJQqiXfdI964mL73rk2MuJP1mA1ea
         RU3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792543193; x=1793147993; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yRIGCmBCLZXrskue80uJ2gMa4RxJkt2FFdVYi0NxvFw=;
        b=AA+ACyLSOojXpmmA8SZxUC+ilEDCNoPIZr2o+AAkM0wyZsxvkExHr+SqCXGcf5Hmft
         53i5l0XdGjfcS14T+9iApuR5c3beFDdXvBVEzjT0pgZdo+QZocmedbLTF8SDYGg2yPm+
         gY0ykPtL9PW7lQa5/tLbXW9j7BkM8SjVwl244rk2KXhViY+PWIW28vSmSJ3ZzNT15NXO
         /LhvAjAD1wBoY1VAIj0gjG0t9+JTDGtVINl86XV+A1zYqe0hoeERKBOx0KNlARE6DFEm
         fzWBSxuvrAAHNzW/CRLZlNtOcozZ6kpOTwh9OAOUSWRFKVB/qw14dPSjwvt/8KHJlYeI
         IQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792543193; x=1793147993;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=yRIGCmBCLZXrskue80uJ2gMa4RxJkt2FFdVYi0NxvFw=;
        b=0znWgICiy+VNwiKC6rGSw5ARlicmsYHX3YbeQPvx4qfTB3CYbRnDGgRKmJp1faGr34
         fznnCvJ8dcKPBMou+UeEoq+DyFGAEn8CEqpwM1mf7HAaVMPmaQxbtyBCMLQD7ncAPhH9
         +VtiJyfrvKCaCs2dOm3N/w+nTeuuiAvr2tmrR2zP8BBD6sNaQW0Sod0yv6cbDKZeahWc
         kCNFmxAg8TuSBnG9tQxHEF0z/yt1Oo0qGzB0sXwdyvfMWbrmven4fqleH9GzY/wit3/q
         ZX0SqvtNd4Qxj93bx+G9MFc55zljBZk9RJg5ZcNHqojvhKXleXkPPCdSezjIRCf4EEDs
         /Lnw==
X-Gm-Message-State: AFq9FYKyggToBDWLSXoYChYt9/kvks5KKMKnjx9ovh3DV1GErN0lYbba
	wGYVYi5uPc9JyTZPLcaQWGg/aCNbcOPpY40w5GWDiBOIZXFft7ihx0fSb+ceDSjJzG1XUjo1dTy
	Oi80JiIkq5HnNz6SwArqjd8uI+NS52dyGvKEqZrgIcw==
X-Gm-Gg: AYBFou3quZDdFhhep3yr/RvqF8/fW5Hkc7+jd1WvjlrLY+QOQRFt3JACt5anHIxYg1e
	6yKr+QCbUVo51PzPYu/KmPPiE7lZwo/I3RRiYQwjNZWiwvWGO+2583hiBv6C0hTB+EPesXtClDU
	+YKMT/BS7GAqyui+8bydoefQ86Kop/D0fM5X2favHB6yFoB8ig6u3we+QZQsKnHx2+g6WcD9S67
	3e2CZ9ZKqvD9Si4mqA38c2vdFky1O2f+tvmZ7eKBeLfFk2u7XGJRnABnbCx00x/DttBAo4U3vbO
	vP2NzFADowG4jB0ENmhJ/vJMWrpz+lQ2/0bUwJ9bFuvJuBp1nWTuAYa09BcFbQYeUUJUimobPB2
	WgvCwVHYtxw==
X-Received: by 2002:a05:6122:5316:b0:5ea:b9b5:8c43 with SMTP id
 71dfb90a1353d-5eaebe0552dmr193146e0c.18.1792543193001; Tue, 20 Oct 2026
 17:39:53 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: mixalhs <mike.michalo@gmail.com>
Date: Wed, 21 Oct 2026 02:39:39 +0200
X-Gm-Features: AclHuK-p-6jHmmFtAn8ZlfPP0jgzDBc8fS7hal7SGHDBcgq1FOZA-oWjl887KHk
Message-ID: <CAO+rqLhpPvY0NLrAnZjFXz0gOXnA6zsXxK8xCgtA42XUkSsAeg@mail.gmail.com>
Subject: ksmbd: Kerberos login fails on 7.3 with released ksmbd-tools
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi Namjae,

Kerberos session setup fails on 7.3 with the latest released
ksmbd-tools (3.5.7), and ksmbd-tools master fails the same way on 7.2.

struct ksmbd_spnego_authen_response gained a __u64 session_expiry field
before payload[] in 7.3 (commit a47634cd729b, not in 7.2), making it
168 bytes; in ksmbd-tools 3.5.7 it is still 156 bytes.  ksmbd-tools
only gained the field on master on Oct 18 (4c0ca83), after 3.5.7, and
always sends the new layout.  ipc_validate_msg() requires
msg_sz == sizeof(*resp) + session_key_len + spnego_blob_len, so any
mismatch is dropped.

Tested with a local MIT KDC and smbclient --use-kerberos=required, same
realm and user throughout:

                    ksmbd-tools 3.5.7    ksmbd-tools master
  7.2 (mainline)    login OK             NT_STATUS_INVALID_PARAMETER
  7.3 (ksmbd-next)  NT_STATUS_LOGON_FAILURE   login OK

In both failing cases ksmbd.mountd logs "Authenticated user `testuser'"
and the kernel logs "SPNEGO_AUTHEN_REQUEST failure".  NTLM logins are
not affected.

From the code, 6.6.y, 6.12.y and 6.18.y also require the old 156-byte
size, so a ksmbd-tools release built from master would break Kerberos
there as well (only 7.2 tested).

Would you like the kernel to accept the old response size again, with
ksmbd-tools sending the new layout only to kernels that support it?
I'd be more tan happy to write and test the kernel side. :)

Thanks,
Michalis
