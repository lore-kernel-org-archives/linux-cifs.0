Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0764243F0B1
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 06:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786082419; cv=none; b=j/24lespvaCFwu43MOp3NQYlVyttqWDcfK/I0hREekzGQZswy2SlM2Ic4RW7KPNc3YgSwSr4VAHAoVODC+9iC69FPZFdhIDj+YF3/d9rjxkzOCeyiQEEA1klCA90XPvp/KmCcOh52a57dZaTF+lUawJ3sXi+cYMOxfRfSiDFRCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786082419; c=relaxed/simple;
	bh=fJIcDgsprPKPdP15Oe4J79LT+8p2rROJkLgh5Rri8nU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:Subject:Content-Type; b=ZIaZoNrpTbKbILqu9+r6UhhjFdgJzSu5WpRyrkptiBU95D2lvDxjS/vgnweyo2ivp4fpZY63eGJ5wxtHgnGBVh4PjZZPMBPtKxVgJSWDLjBek502hVDKRmle5CG64baSxuO3/YYgAdEkKEeh1iFkRwsNgWok78uVi3xK+4U7ZXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mstefan99.com; spf=pass smtp.mailfrom=mstefan99.com; dkim=pass (2048-bit key) header.d=mstefan99.com header.i=@mstefan99.com header.b=N2+8N67i; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=monK7wTM; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mstefan99.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mstefan99.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mstefan99.com header.i=@mstefan99.com header.b="N2+8N67i";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="monK7wTM"
Received: from ams-compute-01.internal (ams-compute-01.internal [10.64.2.61])
	by mailfout.stl.internal (Postfix) with ESMTP id 93A041D000CD;
	Fri,  7 Aug 2026 02:00:15 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-01.internal (MEProxy); Fri, 07 Aug 2026 02:00:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mstefan99.com;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:message-id:mime-version
	:reply-to:subject:subject:to:to; s=fm2; t=1786082414; x=
	1786168814; bh=kMo9snTUaFjFmlk3QrgEP0rpeTx0NHy+9h1IFwBYxBo=; b=N
	2+8N67i1rG35264Pkw/NYtS1hLy/nVWBvJHziHOOuYd7tnDxkomM6dnESyVrjuX3
	J0z3eSJAOehOCRT5uAwfyM+y4U/HkbB4Y/M6ntysgqhd3NQad39Fd6pKFK7KuAvu
	ihyw8zs983LFeKEoie4p0QQbatLbMVurA4qeulloEwnRDsZRPRGpKEonXqCSxbOZ
	mK5ixEPnuU49VMZ9X8VmxRC4F49ch2MIVLwA5AxrgsXbdgaCzNaECbKgXJ7L0FSO
	h0ZXgjUYL7ohXJp5ODwDngLH7SVPveiEhRlcnBe0BsLr0VgG23DrO8zJU/fvHl8L
	w21IGdFQd8qttaKahj2cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm3; t=1786082414; x=1786168814; bh=kMo9snTUaFjFmlk3QrgEP0rpeTx0
	NHy+9h1IFwBYxBo=; b=monK7wTM0DphDpPHAxcCQeNPdEF+wTENrr+FOJ6OmjGG
	ZWufJ91W2f7GHY0DM/jUTvGgphmYuTFgtlKj6DrRPHSCJY6R61kQYmlal3SOhN0y
	LcstYF19JjNYqRjHkqzKYgWg4TdaIPu8EhGUTs5M+ByNpuO5kWDFK6xTPwH+/KXb
	kMFu/7i3hPnOr8arYta/JMehoCroB6iO9/u34NNNRNb1PVldRCy0igg1vKAqBryR
	hzMIDKKIVg1AbhTWETfrLU4MmeOQNKn3gn0jjSyl9QMSQXNnbkbxbWAIhKO2Ua37
	UrWF4t5OPEIpbSBTzgXzfBBZVSRGR2zz/aQ25veRGg==
X-ME-Sender: <xms:anR1aoB36OagtcKMCxDD_tuvDTwFKfMmZ5g3Q8hYVnOgTcHjyxHF8w>
    <xme:anR1alW15jFlwwvqfEwZkGyQ4iPHd7pbptwZTJREP-Tkz4-WIe37vWRtJA75SlMQ8
    ByxSmGyv0J6kizTZMq6u7G0Q8gMARHbINspBre9iI3h1PLsHbjl9QM>
X-ME-Proxy-Cause: dmFkZTGgHPnxSpxceQvduWxR6RqH9lz1Qp5UE6RCc1yDrUoMvYBSuB2oNbn9IyFFeXPQ1Z
    Z390NeDWl12yruAaAIZdYDTXL9CnUfqgKBYWtZz3NmCnRolumWQyqt417nEBFhGSCbDqJY
    TZPA5u76d93nqlcn8aQ9oqeKiAo+2pScnVXa8Zyweh7oP4lc3X9KgCODjnx2+swHh9MLaP
    X3bXyQtsqVe1DGwtVtfvXTDTqwfrYwhY9FCseNkqllqWuyJ9JBNBjbMANkOZjOizuMyRoD
    h9sDJwsNhBkLdaZW1UmOTxbkY8sF2cDhDnpjky0JnKJhaYq/9vdXuz9gjf5PtcCt3bfsh/
    B2MA4w0rZIpktAqeSdz226a9WwdmWs3YvI0BctoJ28QmnazkdGAQHMXFC0jHLTebYpdEI3
    C80gAfU1iQV9oILov3aq4ttDnQWdi+9vEZd/9SSi/txekybnGrzlRfSrLUVtIXXQUlxsLW
    4d1FgxRV76cS0QU/oWRNgjYfiz2axE/yHicg4KX50+iSeNJFmUc7DDtBOtG41WmInY3u5U
    VUXvHDBlB9hZ+L5sEvK3g8i4/rE6E2sqRqnvM0GE+T7pvxR71yTa5mrPXxw1gKK9vgf2uU
    9ohxoOn3fL0AxVVc9+dmUiv7rCHTJQ+R4wfQAdkyMazmAeU6XQbJnFdurTXA
X-ME-Proxy: <xmx:bHR1ahp-5VNA5bd6oWmtbwcNJhg0OFLKx1fLM9uuSX7Sto6Ht1Dp9w>
    <xmx:bHR1avFakAIHDLEXTW-HOCwOAnekdnAEPhmwHssrNt6zVwJhBOFkkg>
    <xmx:bHR1ahtSQiUefl5vhxeDnOQXJiYAuop5wV68e_L4VPOjR8AnXPGySA>
    <xmx:bHR1ahUeEqnF09iq6erspNunOro-20N57nrmae2zBJKLvqhOtF9TIQ>
    <xmx:bnR1astCbR-xQ1oRLHdpuYZ_29UOix6GHPpkZ8yG5mP1BI7i3p9DOmDU>
Feedback-ID: ie31c46c3:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 87D7032A0065; Fri,  7 Aug 2026 02:00:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 07 Aug 2026 08:00:10 +0200
From: "Mikhail Stefantsev" <mikhail@mstefan99.com>
To: linux-cifs@vger.kernel.org
Cc: regressions@lists.linux.dev, sfrench@samba.org, jforbes@redhat.com
Message-Id: <75fb5359-b268-492d-8d4a-504d1af60f2a@app.fastmail.com>
Subject: [REGRESSION] cifs: openat with O_TMPFILE returns -1 ENOENT
 (STATUS_OBJECT_NAME_NOT_FOUND)
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hello,

I have run into a kernel regression where openat() with O_TMPFILE fails with ENOENT on CIFS/SMB3 mounts, breaking atomic file saving in applications like Krita. According to the open() manual page, the ENOENT error is supposed to be returned when the path (a target directory in this case) does not exist, while a lack of support of O_TMPFILE by the target file system should be indicated by EOPNOTSUPP. Applications receiving ENOENT wrongly assume that the parent directory of an unnamed temporary file is itself missing or inaccessible, aborting the save process.

Downstream bug report: https://bugzilla.redhat.com/show_bug.cgi?id=2499750

[REGRESSION DETAILS]
- Broken in: v7.1.3-200.fc44.x86_64 / upstream v7.2.0-rc2
- Servers: Synology (Samba 4.15.13), Windows 11 Pro (25H2)

[STRACE EVIDENCE]
openat(AT_FDCWD, "/mnt/vault/home/Drive/Sketchbook/Studies/6.07.26.kra", O_RDONLY|O_CLOEXEC) = 37
openat(AT_FDCWD, "/mnt/vault/home/Drive/Sketchbook/Studies", O_RDWR|O_CLOEXEC|O_TMPFILE, 0600) = -1 ENOENT (No such file or directory)

[DETAILED LOGS]
[  106.251673] CIFS: fs/smb/client/dir.c: VFS: in cifs_tmpfile as Xid: 2886 with uid: 1000
[  106.252152] CIFS: Status code returned 0xc0000034 STATUS_OBJECT_NAME_NOT_FOUND
[  106.252154] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2 status code 0xc0000034 to POSIX err -2
[  106.252157] CIFS: fs/smb/client/dir.c: cifs_create returned 0xfffffffe
[  106.252159] CIFS: fs/smb/client/dir.c: VFS: leaving cifs_tmpfile (xid = 2886) rc = -2

[MOUNT OPTIONS]
//vault/home on /mnt/vault/home type cifs (rw,relatime,vers=3.1.1,cache=strict,upcall_target=app,username=MStefan99,uid=1000,forceuid,gid=1000,forcegid,addr=192.168.1.10,file_mode=0755,dir_mode=0755,iocharset=utf8,soft,nounix,serverino,mapposix,reparse=nfs,nativesocket,symlink=native,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1,closetimeo=1,_netdev)

Please let me know if you need any additional information.


Regards,
Mikhail
