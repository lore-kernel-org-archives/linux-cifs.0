Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5AB33C197
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 02:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773194792; cv=none; b=NBs1dUQChf7905OXBMDJ918UZbnEne0mNF13lFcsdwXvP4Sx8F3aocAetaUyb18TAcX404DtihrzCh+NlMxoKkjRpXK8rkeREY+TioB9lVksIHBd9dTp32G1ax30h6F+NY+I98i6CTmQHpYIQJqCktqK4E9amLghCRXdSM7SWX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773194792; c=relaxed/simple;
	bh=P1+ZQrw/a3+oxXwntvE4BjS3zMiSxriGuhAOi6EH3nU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uCwcIfN/qJD/IpVjx3JM/oMU/eppY8PqtqwSE+RvWBTzXFycAHOtHjgTKfnXYtDOE+zmF2qHPeiMdoHdmaTpfwXq+qJe7utegYNENYCBs70Eup7Ilh6nMZD6gcElSXs2vYgLedKnapRrqVOCv81/gvjQii8FDM33et6GFj93CcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JZFdoL+V; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JZFdoL+V"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-439c5b40f60so6211576f8f.0
        for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 19:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773194789; x=1773799589; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YeasIl4NlVlSUO2J1WHrJ04QPxBi9mp/dFx8NjgnjNI=;
        b=JZFdoL+Vzw8c9AOUjOyLJZhGgJuPJN3+xfi5pXlNgByhuvT2jrIq/nK5wUhuEh95UP
         0mEqIHMcQS+8SqVC1K/Z2H9bBz/mHDaan9sEkjD/n/+KHLrOdyxv8hyg3hj+snvKGVfo
         dnkC/sa0HFle9ntFHcYgqYGY3/cF0owqHjBJp4Ra3HJX0zMsR9aPn9kZQSo0u1SF1RdZ
         DXaPMB2KxEDhwvCSGc9P+yppQkxDcDnIcM9qQ5w+xLZiPed4NAde1VumNl/UDMzhurrX
         c/hVWN70nb7eMfT3le7BdkxvAUugL/fgHBActcXOYhE7LqntKq8hPkqPWhXQxr70eC5O
         3ZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773194789; x=1773799589;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YeasIl4NlVlSUO2J1WHrJ04QPxBi9mp/dFx8NjgnjNI=;
        b=O6To9hGVe90KaR6Fnc8dYv/S9BevyAplphCgzRHN2f2ZbizziQEoSlo7F0u6NKnzg9
         65iwvGi6AHIqbKZGgVo17wWiCmMFRMEZWLwHstWEjPqzjHvtsutu3GSC6J97mskIlVVu
         BsAjiy/q/RDnDLUxUD11xcQ1PgjMXC1UJU9tzna/ReYX3bTPUy8ld3Wn3/qGYGZJj4qx
         rGLYfkVRHoMRI3HIfayKyJzYsQ7Mxd9DLoN6mVlgtBgvYTqPTxpT9+gAKjPyHx1MePD9
         YDdiUIqJcZxXHRe4HReg09mQjuqvlJfh4sgMEZd2qA7Pq1EMY08NPAkLGT0OnEwIk0rg
         fuMQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9hEClLMJBXsnorql217KpQkILYgYSCfP3ae0J/AsTvsG2rDkUfIe3G29pc2bIt1xJLpRH/pqf3p0q@vger.kernel.org
X-Gm-Message-State: AOJu0YybEvzu8tGP4M12VYDCwgvEFLIZH7DNf1cZTloiA0c9CxTan5qf
	fIzaErQv8lNQkf+OLHTUar2nWj+uAcs2Lw+0BGPg9qqraP+LTbq25LovT4eqW6CLrt2sBXAZHD3
	C5jw6
X-Gm-Gg: ATEYQzzO0dyo51wkjNmesCTT5YM8xmhCVdsd30Ju07+YoFdml1j9EljDDH8O+sJ9e22
	yJkKAk8EFFj0RjvfVsj7ssoF3P2310TVsRTW3j2H3y134P6Jj1Zavg/6vWIvqJSija9bhm+Arx3
	WEjKXzvpDX4vMS1F2I4JYeznRyVB+sFIyAEhQ6LLf4Dz69A+NwzpH8kzVKP/54RRFclBtfMvKp1
	4R9tsfGpa7EXc9LJzg4mF7qzM7neRrGpiFWOLzx4WtzEMzLgxClP61ZRT4WSItKP/IvlUz148sH
	mZygIG1TsiKzT0jlGpaPl13d7YJydwDSEudw6YTPGVDfrjqev7OUcl6XX6w6VjAFCGr732CT35I
	KQXKivHco8WA4GSTQe1XQHZDJ84nSKzOtkt6V35I1ASbHi0efyntpu3OSKruriFoIKF/74GTdPH
	6WvF5WMIE7buOFpptXMIM7PlMysMtW8BRhjylyOFwiXL7jOiU898Jfg+g=
X-Received: by 2002:a05:600c:a46:b0:485:3026:2b8b with SMTP id 5b1f17b1804b1-4854b12bfd2mr12821085e9.29.1773194789451;
        Tue, 10 Mar 2026 19:06:29 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6402:b103:6a0a:3e1c:778a:5cc7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be8aa7413esm728571eec.24.2026.03.10.19.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 19:06:28 -0700 (PDT)
Date: Tue, 10 Mar 2026 23:06:24 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: "Dr. Thomas Orgis" <thomas.orgis@uni-hamburg.de>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	regressions@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [REGRESSION] failure to reconnect on SMB server restart with
 custom TCP port (not 445): Host is down (at least since 6.6.95)
Message-ID: <c66p7dr6vlujvnwczbnrmqx7monkdgdnm4rwewm76aibn7jza3@d3uik74dei72>
References: <20260310235642.6d9798f4@plasteblaster>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vyyfnoz5o32eea4w"
Content-Disposition: inline
In-Reply-To: <20260310235642.6d9798f4@plasteblaster>


--vyyfnoz5o32eea4w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 10, 2026 at 11:56:42PM +0100, Dr. Thomas Orgis wrote:
> Dear Linux-CIFS maintainer(s),
> 
> I stumbled upon a regression in the Linux cifs/smb3 client when working
> with a smbd using a non-standard port. I am not the first to note this, see
> 
> 	https://bbs.archlinux.org/viewtopic.php?id=306712
> 
> which is a report from mid last year, indicating the problem sometime
> after Linux 6.6.72. It is a very simple issue, where details of the
> kernel builds or mount setup don't seem to matter much: Older kernels
> reconnect to a SMB server that was restarted (old processes killed and
> replaced), newer kernels do not and just have a defunct mount.
> 
> I reproduced this in our HPC cluster environment with such smb.conf on
> the server side
> 
> [global]
> security = user
> map to guest = Bad Password
> server role = standalone server
> smb ports = 1445
> 
> [public]
> path = /some/path
> guest ok = yes
> read only = yes
> 
> and such a mount command on the client:
> 
> mount -t smb3 -o port=1445,user=guest,password=foo //server/public dir
> 
> When I kill and re-start smbd on the server, older client kernels
> reconnect and continue to return listings and files from the share,
> while newer kernels give this:
> 

My suspicion is that the regression was introduced by:

    5713127da855 ("cifs: update dstaddr whenever channel iface is updated")

That change causes parse_server_interfaces() -- should this be running
without multichannel mount option? -- to overwrite the port stored in
server->dstaddr with CIFS_PORT.

The attached patch preserves the existing port from server->dstaddr.

Note that I have not yet tested this patch or confirmed the regression
with a bisect. If you can't, I will try to do that tomorrow.

-- 
Henrique
SUSE Labs

--vyyfnoz5o32eea4w
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="patch.patch"

From 1218840331eef3a6b523ad39e851a412f570b7d8 Mon Sep 17 00:00:00 2001
From: Henrique Carvalho <henrique.carvalho@suse.com>
Date: Tue, 10 Mar 2026 22:52:52 -0300
Subject: [PATCH] smb: client: preserve destination port when parsing server
 interfaces

parse_server_interfaces() initializes interface socket addresses with
CIFS_PORT. When the mount uses a non-default port this overwrites the
configured destination port.

Later, cifs_chan_update_iface() copies this sockaddr into server->dstaddr,
causing reconnect attempts to use the wrong port after server interface
updates.

Use the existing port from server->dstaddr instead.

Fixes: 5713127da855 ("cifs: update dstaddr whenever channel iface is updated")
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2ops.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7f2d3459cbf9..d3cbfb3fdfc9 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -628,6 +628,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	struct smb_sockaddr_in6 *p6;
 	struct cifs_server_iface *info = NULL, *iface = NULL, *niface = NULL;
 	struct cifs_server_iface tmp_iface;
+	__be16 port;
 	ssize_t bytes_left;
 	size_t next = 0;
 	int nb_iface = 0;
@@ -676,18 +677,20 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 		 * conversion explicit in case either one changes.
 		 */
 		case INTERNETWORK:
+			port = ((struct sockaddr_in *)&ses->server->dstaddr)->sin_port;
 			addr4 = (struct sockaddr_in *)&tmp_iface.sockaddr;
 			p4 = (struct smb_sockaddr_in *)p->Buffer;
 			addr4->sin_family = AF_INET;
 			memcpy(&addr4->sin_addr, &p4->IPv4Address, 4);
 
 			/* [MS-SMB2] 2.2.32.5.1.1 Clients MUST ignore these */
-			addr4->sin_port = cpu_to_be16(CIFS_PORT);
+			addr4->sin_port = port;
 
 			cifs_dbg(FYI, "%s: ipv4 %pI4\n", __func__,
 				 &addr4->sin_addr);
 			break;
 		case INTERNETWORKV6:
+			port = ((struct sockaddr_in6 *)&ses->server->dstaddr)->sin6_port;
 			addr6 =	(struct sockaddr_in6 *)&tmp_iface.sockaddr;
 			p6 = (struct smb_sockaddr_in6 *)p->Buffer;
 			addr6->sin6_family = AF_INET6;
@@ -696,7 +699,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 			/* [MS-SMB2] 2.2.32.5.1.2 Clients MUST ignore these */
 			addr6->sin6_flowinfo = 0;
 			addr6->sin6_scope_id = 0;
-			addr6->sin6_port = cpu_to_be16(CIFS_PORT);
+			addr6->sin6_port = port;
 
 			cifs_dbg(FYI, "%s: ipv6 %pI6\n", __func__,
 				 &addr6->sin6_addr);
-- 
2.52.0


--vyyfnoz5o32eea4w--
