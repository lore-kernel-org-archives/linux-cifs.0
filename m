Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5BB264638
	for <linux-cifs@vger.kernel.org>; Tue, 11 Mar 2025 20:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741724516; cv=none; b=rJPpdMD698vt03P3F7Tlq4djItcEEtx1Gygnoj47XuCIOKrpcwhaVbfxOAP/vBK9g0+YgThmEt3wzyX4EB0mJVmV3oHYfHqeQSRSa1S2hEW7DzbBcdDQUV1Glg5ulR9tc31EuGLPLa8Dtflw84dJYeyIRJpGdguQ4HT6N0xbZEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741724516; c=relaxed/simple;
	bh=Vov0sdfnH0pMExaF1bG1SBHE8cvGmRm9OlqcQkNc6sQ=;
	h=Message-ID:From:To:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=WLsp5Y5CZ+60/+NQjE5UITimGFCB1KA2rzkTMn8n4QSCldo149ek3nongKwZ7/JYYAmKTj1/yf7n1qPu/C+ASXIpzwKFGie6DtjWTxVvV7+9MkcqN7/UjRSLTjM0t5l2N0F6WnWCOaLIuX61gHuN4uzCEXJxuyNB8azZbpzhLsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=gXLubxSH; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="gXLubxSH"
Message-ID: <e64f3f2231064e771423f32865361c10@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1741723956;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OmHCokL1pEq1E0nY4Ruth51FEjIaMBiwg9Bq6dczU14=;
	b=gXLubxSHIw0mon9YmoJqDqelI00brWHwaJfzMqNFWmUSAmNU/ZzlSKYqgJr8wWvsz5u5kI
	i0MsZTAOM0MpcJtFJFQkx5k5LrY4soj8RdgQcBNsC6HmNU0dSZ4SP4WBKPssK87S/YxQmk
	h/VinMfXPi1bgta6HOz518kAi0XYX6SScFHGM5fsIsvKx+CRfX8Jau1cThZiMAX4Dv30br
	4/UjVRBYmOa1zEkX+q8Vmw3OdHxGFQcajcfA5VEl+N7iw/VMVsZbZ3i5X/DBpg/kGUqBXq
	JkHS3iMpQ/OkClB4BjoJgJV5U+qET7sLa/xwbbgu1YLy2c7lrpduua0cf9batg==
From: Paulo Alcantara <pc@manguebit.com>
To: Adam Williamson <awilliam@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: Anonymous mount of CIFS shares fails with cifs-utils 7.2 unless
 'sec=none' is added to mount options
In-Reply-To: <83c00b5fea81c07f6897a5dd3ef50fd3b290f56c.camel@redhat.com>
References: <83c00b5fea81c07f6897a5dd3ef50fd3b290f56c.camel@redhat.com>
Date: Tue, 11 Mar 2025 17:12:32 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Adam Williamson <awilliam@redhat.com> writes:

> I have this line in my /etc/fstab to mount a local network CIFS share
> that requires no authentication:
>
> //192.168.1.9/Media		/mnt/data             cifs    noauto,nosuid,soft,guest,uid=99,gid=99,file_mode=0777,dir_mode=0777,users,vers=3.0	0 0
>
> With cifs-utils 7.2, this suddenly doesn't work. I get an 'invalid
> argument' error, and in dmesg:
>
> cifs: Bad value for 'password2'

Yes, this is a regression.  The problem is that cifs-utils-7.2 is now
passing an empty password2= for guest authentication and the kernel
can't handle it.

Does the following fix your issue

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index e9b286d9a7ba..456948d4f328 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -171,6 +171,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_string("username", Opt_user),
 	fsparam_string("pass", Opt_pass),
 	fsparam_string("password", Opt_pass),
+	fsparam_string("pass2", Opt_pass2),
 	fsparam_string("password2", Opt_pass2),
 	fsparam_string("ip", Opt_ip),
 	fsparam_string("addr", Opt_ip),
@@ -1125,7 +1126,10 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	 * we will need special handling of them.
 	 */
 	if (param->type == fs_value_is_string && param->string[0] == 0) {
-		if (!strcmp("pass", param->key) || !strcmp("password", param->key)) {
+		if (!strcmp("pass2", param->key) || !strcmp("password2", param->key)) {
+			skip_parsing = true;
+			opt = Opt_pass2;
+		} else if (!strcmp("pass", param->key) || !strcmp("password", param->key)) {
 			skip_parsing = true;
 			opt = Opt_pass;
 		} else if (!strcmp("user", param->key) || !strcmp("username", param->key)) {
