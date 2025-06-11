Received: from sonic315-8.consmr.mail.gq1.yahoo.com (sonic315-8.consmr.mail.gq1.yahoo.com [98.137.65.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28949220F33
	for <linux-cifs@vger.kernel.org>; Wed, 11 Jun 2025 05:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=98.137.65.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749620655; cv=none; b=te0TPMSJuLQJrVkg/JKdRkFLFop8i2MNQ5WezrFUUgznxtvPI6dWb9YXiGshSGoPXZLs22R5AWt5w7NrE+D5v+Lmu0QtOr7toH3iaeK8whwI9U10P8dVdw37Syl8u0snJsOym4d/cKKeYU5xaL0H3en2m6uoutySDmi52oKgeYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749620655; c=relaxed/simple;
	bh=xkz+rLYWwQ9Bbu0AhHhdohwE5vGavb+AD7Swv9LJt7g=;
	h=Date:From:To:Cc:Message-ID:Subject:MIME-Version:Content-Type:
	 References; b=YPeVrMp51cFoSnRtvs4SlUeHSs/ksJw3nIxdJeuRY6ziwiwS3J9L5gBNj+rsfzoHwGmLAbnlCUyh+3VPSD6MNm+zv5t2Fik6vXYxhzxUi6Xt0wZrgM+O0oLrO/2oJm06+1CKpdd7ExdeS/LNE78EbpZU9juKyYNFOe89+B/qtgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aol.com; spf=pass smtp.mailfrom=aol.com; dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b=SS/Ee1qu; arc=none smtp.client-ip=98.137.65.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aol.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aol.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=aol.com header.i=@aol.com header.b="SS/Ee1qu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1749620653; bh=xkz+rLYWwQ9Bbu0AhHhdohwE5vGavb+AD7Swv9LJt7g=; h=Date:From:To:Cc:Subject:References:From:Subject:Reply-To; b=SS/Ee1quRWGDWQjWFvx1ouL7ojAMSXbOVv/vAsqYmqxXcaW5EWCYaf/xjAV81lsDfx0hALnwGLFLEZdbEufOtDjQpUDgvESCgAfSg5LaeQirOZJ5NnEeGzu0+ZDkK25Nwck+MRDl1dnnSKcn2flM5838pdIp9bnQIRDOpPMMH5AD5gkfQOCb7VBLijwtUcgHWFbHHvLD7Crd9dovYQcIUe7b6H4O3IOf9zIKhYrL/CgEtrLasU24jrycJKo5fM1pReKXbsVMUncHr5reLiONo+mbs+3jNjuWBeSGi5mLkwAnkhder6cDRMRnbB5rjt3q2Ipio3c5SSNzXuRfb455dA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1749620653; bh=7Vqp/txxSYljkjf2cup8AMbd0AnOgfbqMQUq/7e6VeY=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=a96j5tprsb9/CR0OtcdpfBFXrQBmljSkEwalFfXsxrUH1g507utor2yW6LrFOM9hGudcEJx3sITdCE+bCSoHMR6+pBJAc3l8FU4ss/jb+KB50GcIxRcDFW9lKWmJVph+FmdMm37UH83366wWe5cYS1QC16HpeJwlyrTCpS5LdD17dNk8Yq6nF0TqZfQyleqG+wYQxjiPpNynKvubNrp8cWUfbhiKJDEl2tl4BV7UnemP6GkGAByzE5lAz2hu0W/cH1eRIer/oRwDAG0d6QAbhXlIWBtLg0arMo3sH7ba+36eTYaPYlvP14kajrAXeJbdEY19+pAKXGF0q3hnfSdGdQ==
X-YMail-OSG: Hg9fmO4VM1mOT2uMECq.cQBp6GixzQGTuEEeOCEV_8bejyEWjISAmK4yXGNBUHC
 aKay7dXUxAXMNFUJQl8D.xIp6QKTMnuWfc_zPMGr.MBzVEKOrKkBtvBHEynWU5c4OQDOXdaGb6o1
 1bXDtQV8s6rf5ub7hWhWw8_52mNVqHY_ViuDk3ub9D.iwGQkFxBSX5gycRCqpJdgi4Yb5QD63znh
 fA7H4CU5QYiSpmZa2pFkGS.JYl4avxyyESBGYGqME6KAWk37vGIkDPJ9gURXRVzDdeKpFYMf5.ve
 jE8Qve0Csv6_6xfLyPG9uAEE6pL0rO9BlPAz73qxC2JLF.XdNrvhaed4qvznQGzcevFd4QVNduzc
 pQ7E0rlsMdlg8GbOV_3Ekw5gW8UE_4OPA_mrj_5Bk.4yKFbRAGvVU4BQz.mQZ_88NlNj1zsr20cl
 td54e21ya2xx9AoQO3WynPhbycjpEnfCCwCxoX.e04rq.QFWZUTUmUhZj0Sad1ZKSgdhy1j2FgQf
 yroDqgknFLch0eZqliLuhknewckSUSLhVq5vH0MksSxcXX_M1139GpFMcLXIHD8hODxcmNwhaw8v
 0sZq4x1KPSmGiqvoJTKEVm42wqJFNlCW3I9ja8SHPw61kzHI9PrpLmsZy41Q2XcAYjMff5nQvlhT
 PeQdrO00c_Ni3DqnMGVOMAe1caTvmkzK0xI0zg4Xg43SK9gXu5vqQWPg7RDpOZoF3iMRJJBDEFDu
 PZ9X0AsrXTfWHkt5HsYA5tR5x5ucOYjA4jyuj8IWkbriqyW5PcOadyMnBLN7oIr.xjR19dtwrFiM
 pyqNMQFZaHEbkycDMnXYqxE9Anw6ISjwpz38yvt_yqpAaG51zGea1tFxdY0nAjKcHfPdgoa.96wM
 deumCG1UsjjaGby_xINEEgdnO47W4FxKrbv21fksaUsWkRlWOAH7Sws78EIJCa2gHbT9a_m1S2uR
 e8lXscLB9P4LlNs2gXoOYctRYygio.so0ShztNKTqBGhRAZBJBXyc8Y_ocUKpSHv8Vd7LCPRfuBs
 c9CC.QFHz9u.PUc.Jg06xRNVK5fTSBxKmlAC.OiOLbHnZxOLaulATbLVN7lyaY6yIGynVjJAO7R8
 5Mp1QtUzsDH03CaAIpus2vPVOVgtCI5UemqAWc54cbW_zRGVkp2dwuWvn.AngnYeevRvBCw4RVpc
 E6XXdOQUuTOh6G2SerMr4lZaNDjE93VBB7XS8HBYKVr9YZkWkSCyGSm5SfprrklZYmse1yy_QJDE
 ZwTnImfKofGkUqOfGcIPmbM315ax.E6zrlkkL5IWxVzQ.Lp41qy0ya3NHCL7IO7orvRRQ5Ox39CC
 pxJLvBbOT8OCSSL.LZ5NSM81WBB7vPWUx83sR9HO_EjZmGShuAjb3o6cRXcNXQ6F8K1oRKCG3lEv
 pHU6U0MclHWG8lzbZCVmmkRhbvczoJMFndSFZV4aITyzM4evFZBmeZAGO2eqbpAjgwRH14otNeMq
 cnLjfZu1ZNzFzrVK4PDdkgEGMItzREPwXJ_OyKSdFAzMSJKqOjMfCoQrUkkxLyHebguI6.Ezt7Xk
 ndgvmV1vk3GWlIhtj_sIj6V0uZ.Oj_yCZiUeRs7VV5jORsiZcdo5yPFdnxF8D94XuwnlJzLgzmn3
 RdSMeok.c9P.WKeLkjv5C27wooiV524nIJNEq2iFJ66T8EE99BYpGDi.wRSF9lDQtroNtjB_SoG_
 9rBiX6SAZBqrShPixJTSnWKor7lZUmWMiuwvJJe_O40EQuMgbT__VK7xhdhCmFDRBVZkK2VkAmZU
 xjpi8SXFIKT5Kl_Vv9H9DjF2dXzHNr1IzoN8ottRswhE2zRyPOMGYLNvxEexshJijx_GEMY_MV5_
 VrVndZCEpPZxz.xs9rsX0rVUZpp18cYR3TVA7qQL.erFcw3XiJw..Xui9MxByqZyuM01Mxa7NB1q
 BN8Nl2544_Y.GK7ld8IkPCF.yulEZus_SHevq_PprUwYi30RYYLNWHI0DaZpTCqnmhT8g9Uw6sd7
 6gIPgIOBHPR2S17rkftg.F2a0_b3O3hegxrc6qI33WPU_v7YbPLDEH9WbudorkGFQnFSga.XbcKt
 Uw.MnQHMdVPKJulFmjpbQ2ygLNtna1c4xVMYgv558TCeJc6BQXZBTBcIOPi51OUZ.Ui2tpjqAqjv
 _Pk.mGbCEzss_W4IF.xwa6FTmW9dpkurfpVgOw7q1YSMFtNrXzSfcWsEO2U8ebjk45Ibsi3Y-
X-Sonic-MF: <canghousehold@aol.com>
X-Sonic-ID: 49902f7a-024f-4a91-8672-a018bea0d946
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.gq1.yahoo.com with HTTP; Wed, 11 Jun 2025 05:44:13 +0000
Date: Wed, 11 Jun 2025 04:33:25 +0000 (UTC)
From: Household Cang <canghousehold@aol.com>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Cc: "sfrench@samba.org" <sfrench@samba.org>, 
	"stfrench@microsoft.com" <stfrench@microsoft.com>, 
	"sashal@kernel.org" <sashal@kernel.org>, 
	"pali@kernel.org" <pali@kernel.org>, 
	Rowland Penny <rpenny@samba.org>
Message-ID: <1192550962.455023.1749616405217@mail.yahoo.com>
Subject: Userspace mount.cifs -o cifsacl Mechanism
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1192550962.455023.1749616405217.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.23956 AolMailNorrin

I am trying to grasp the mechanism of cifsacl in mount.cifs.
I fought my way from joining a Debian to AD, using sssd, doing dyn_dns to heed Windows Server's RFC 2136 (found systemd-resolved is incompatible), reusing krb5 ticket for mount.cifs, piping sss idmap to cifs-idmap, now currently stuck at cifsacl.

I am doing this
export KRB5CCNAME=/tmp/krb5cc_10001_xxxxx
mount -t cifs //nas.domain /mnt/drive -o sec=krb5,cruid=10001,cifsacl

Something is wrong with the cifs.upcall that it does not like extra xxxxx unique identifiers being appended after uid. I can blame sssd for doing this.

/etc/cifs-utils/idmap-plugin --> /usr/lib/.../cifs_idmap_sss.so

Once mounted, I could use getcifsacl to look at the DACLs with the resolved name from sss.so
But the permission is not enforced through the ACL.

I am seeing OWNER in cifsacl is set as the uid on files.
But all ACLs on Windows AD groups are not translated into ACL. So unless I go do -o uid and gid at mount.cifs, they all remain at root.
Is this the current limitations of cifs or I am doing something wrong?

Many thanks.
Lucas Cang.
