Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB80228751D
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 11:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763465939; cv=none; b=TCktbi06uVJ793CaJnXJcBQ4IEI2yC1HuRFjf22parqTEJW6z7xpJu4MAPIdF26KUyoZVPyBsAAwL/PHhrPkZERWBe0v0iWepLJINgHqpjxEio8X8asEzucWNBrinY+rr885heZEYCqUvWKtJoHYXf6a/W1p1ts+9f8JBZ93GuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763465939; c=relaxed/simple;
	bh=W3S9t0ZF+VpBlGtXSABDwdnzRvSPtKnMqYnDDbZAt88=;
	h=Content-Type:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To; b=aXn0kU+cBHIkdcI7ZOxAyf9VuXkdLfqKQzXyf3HR5VOnqCEtBuwVJ45IMhigWkHdAYWxt3u14rslqsDkawPXp+dMhdLmSDqiiwRc0ROA4VWDAZUwsw9B91QPSO6eEQju5HOG40/Dmn/H90ABOcjOvAxqe0Po4tHAHe+6NTWT5RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Eb4W6s5C; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Eb4W6s5C"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-298456bb53aso60445085ad.0
        for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 03:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763465937; x=1764070737; darn=vger.kernel.org;
        h=in-reply-to:from:content-language:subject:references:cc:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W/yCTXg3AWy6SLLby4V162IgvIaEjo1KwqkdkMgRBb4=;
        b=Eb4W6s5C7ejuYWiOgTla1EHOuBxrBcShv9AYZTDIHOUFRMCXn1ctWuNxHpceVEu8lb
         yYcXQqyD/w4fHqeNFWTOAxaSvcxDfXcizdMK//iKKlHzHX8QxTD+mhZScucqmx5bUsEr
         AZotkgEzhpq8INjwXosXFvM0eCjOw9V8NPfT5teFoOTKVm2eKWq6EpJQ1vbNyejOi/zV
         XDdzYHZ28ktsx47s8ogjn9ReG0NxEFtuYyQG8xnq58Llg5U9XsxZWeGWfQpe/51qysbh
         Yl5zNSrcdxBWVw+gOuXtkvFgm+x5J9Pr45pAIRu1Ics/23eaNUP/g2WONAa6P/ch0Ttg
         UonA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763465937; x=1764070737;
        h=in-reply-to:from:content-language:subject:references:cc:to
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W/yCTXg3AWy6SLLby4V162IgvIaEjo1KwqkdkMgRBb4=;
        b=w/gS6aNlIECLF7JnA4uQ3Ezyeofbnn/VRNYq7Yy4OlJAcqRMBoXqdgTpRCzCJH/3Ww
         RfA4Ioh4dvj4eNDLlMP2pZn2ACP0Eosm0T4MDXo115z1k++YBD83Pr0/cxu1DiQdgBSH
         9F6/JuHPOgXCF4aG2In/agjXjCfJW3C6Adr3YHGZq0vwBCrsY28/JngdAAfqDk38KVmA
         lYUNs8OOrJb6/IHMfk5jN05eWpovzzBv4rf+EcV2KjlbHvLiHpBCnQpS54zl1S4L7iTl
         566BTxOktUHSWDRBTHc+G/dOuOsX0rmHoKYKQO6WtCCKdIRSDmFmduXEpoQIovIvrfGf
         QdhQ==
X-Gm-Message-State: AOJu0YzjHVvs9tBTQEn58XKtfZUYZ+70eYP7eBdI0FgZPPYX6CaJnBAM
	ZzdtJMdp8xV8oes9frnrcqXWXuHsJRXeNSBXTPndUiPlVZ1PdGW8iXpu
X-Gm-Gg: ASbGncuGbvXgwyIrmdWDd/Epkn7H9ODRWsfIqXTq++eQErcjDyLabyWEBqLO8+6U5X6
	IqlhWFxDK+bKPNAKv6FEIfG/9p7p+cq3gksLKbBJ7yZsH3kYFReiXtMwpfk+pAjyNdL3UzpHg0Z
	jtWpfqAbUUpBlXW7F7xt24BlfS4g5zqbN24tcxn/ZfeOPVtlTfwotRKqBxtA14HjHfD1Peu6gX4
	nQAl2mkgGWIiFgWWEhsuFEAB2gkEvMFs9FZFeHhsrwggKyhhjRVxX8f3eChTXbHl5vsJX6az53n
	XcIYTeMb5Jg8cBTZILv+h8GR0tnk6bBTj/LOG6MtXvr9HWlyfNu/Y4+YmjOFZ05bCBFsAQg7jtx
	1XYL1AeVDSK/IiT0g0A25oAuMZ57c9Bdn8fltdqM8vEerp46B0icDG427ANJ2QWykAb9W/BPau7
	Sjt/B3fk5SZHFSsJPcBYsNDz2V/zbfkaVJdbUO9tO/+TdPU+MpNdxkfJA=
X-Google-Smtp-Source: AGHT+IEtKR90s8nKW9tN2SjM0pENVXgiUGeENicSglRlCzldtUKUyh5jo6CRc9OHR4DQS3jjGo2OMA==
X-Received: by 2002:a17:903:1b47:b0:295:543a:f7e3 with SMTP id d9443c01a7336-2986a6f0acdmr185329515ad.27.1763465936788;
        Tue, 18 Nov 2025 03:38:56 -0800 (PST)
Received: from ?IPV6:2405:201:31:d869:12a7:9863:8e31:b180? ([2405:201:31:d869:12a7:9863:8e31:b180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2376f6sm169355785ad.21.2025.11.18.03.38.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Nov 2025 03:38:56 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------w1kLyl0kQk6zZzJHxAqhC3Oi"
Message-ID: <8819ae8c-93b8-4942-871d-a821359ca625@gmail.com>
Date: Tue, 18 Nov 2025 17:08:53 +0530
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <69155df4.a70a0220.3124cb.0016.GAE@google.com>
Subject: Re: [syzbot] [cifs?] memory leak in smb3_fs_context_fullpath
Content-Language: en-US
From: shaurya <ssranevjti@gmail.com>
In-Reply-To: <69155df4.a70a0220.3124cb.0016.GAE@google.com>

This is a multi-part message in MIME format.
--------------w1kLyl0kQk6zZzJHxAqhC3Oi
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz test: 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master

--------------w1kLyl0kQk6zZzJHxAqhC3Oi
Content-Type: text/x-patch; charset=UTF-8; name="cifs-fix.patch"
Content-Disposition: attachment; filename="cifs-fix.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvZnNfY29udGV4dC5jIGIvZnMvc21iL2NsaWVu
dC9mc19jb250ZXh0LmMKaW5kZXggMGY4OTRkMDkxNTdiLi45NzVmMWZhMTUzZmQgMTAwNjQ0
Ci0tLSBhL2ZzL3NtYi9jbGllbnQvZnNfY29udGV4dC5jCisrKyBiL2ZzL3NtYi9jbGllbnQv
ZnNfY29udGV4dC5jCkBAIC0xODM0LDYgKzE4MzQsMTIgQEAgc3RhdGljIGludCBzbWIzX2Zz
X2NvbnRleHRfcGFyc2VfcGFyYW0oc3RydWN0IGZzX2NvbnRleHQgKmZjLAogCWN0eC0+cGFz
c3dvcmQgPSBOVUxMOwogCWtmcmVlX3NlbnNpdGl2ZShjdHgtPnBhc3N3b3JkMik7CiAJY3R4
LT5wYXNzd29yZDIgPSBOVUxMOworCWtmcmVlKGN0eC0+c291cmNlKTsKKwljdHgtPnNvdXJj
ZSA9IE5VTEw7CisJaWYgKGZjKSB7CisJCWtmcmVlKGZjLT5zb3VyY2UpOworCQlmYy0+c291
cmNlID0gTlVMTDsKKwl9CiAJcmV0dXJuIC1FSU5WQUw7CiB9CiAK

--------------w1kLyl0kQk6zZzJHxAqhC3Oi--
