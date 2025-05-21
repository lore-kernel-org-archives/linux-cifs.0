Received: from mail-0301.mail-europe.com (mail-0301.mail-europe.com [188.165.51.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147F222CBE8
	for <linux-cifs@vger.kernel.org>; Wed, 21 May 2025 18:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.165.51.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747850490; cv=none; b=MyGwxg7NpiD3+PCK9xe78/OlnR5v7RQXKh4NvAKQESBEcjZkq5Pcm1yMSf32pJ95G2RVHD911f7+UNzPa4bKhX233ewTWEvBhkjxTug6FBbHsT2pBGXYIz0GNPgIhCHqqQxhsq7A4CzKLfQVTAOFfJOZbCEqwVVVOm/kl7JCpZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747850490; c=relaxed/simple;
	bh=zwX/hoZn5rbs+RJlOGPSFUJHuxflCE5OCLkfWpZBOcA=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=JF+A5FUyW+T837qhRSOQcWsiMWPWLGPNYHgH2vNsyW6UTRxS30XdbfP2yJHE6sipH2QoD+sMmSConC6Uv7Jje/vvu0C25LzbMWtCQl1jpqSuiFUyOXvm5DPiq2jCTeltqOdTxtWX2anzLsYfK0600ZDbjVLDoL0LldE8SJVZiNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=OuYKOgn5; arc=none smtp.client-ip=188.165.51.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="OuYKOgn5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1747850471; x=1748109671;
	bh=o3/Z0q/MgA5vE7ca3jIjLSFBHK6YWx18S47QxcveMmQ=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector:
	 List-Unsubscribe:List-Unsubscribe-Post;
	b=OuYKOgn5+77pg5uyjU9kVJLBtGMvOVKVpdJH3kA7PGJMxg//zOQhuti7OqZ5rwB98
	 47yOb8qru1o5ZmOq1Z0QPq03kbgUR4po+/vab7gl2rcawTCjAZw7LVoj4cDvaaVLDY
	 yoqEZR3khOHyVKFAyXRfTT9n5TKkFcY5pRWUTXP8B7HAHlONXlmgyrVJ8PanNFp9ld
	 fgjFBixbFyjmLWZnOT9iIfXBOpsg3W185Yy3rAJelkT6Ut+IVW4vwqrOgaJ0pRsUGN
	 Cr9uY9Ruji8BOs4/+S4dqUgQ6y23Ba6QTZcUZZqDJ+IB0QlOaLSvT8WlpNOe/0dZf2
	 yX/RMvTq0rHHQ==
Date: Wed, 21 May 2025 18:01:07 +0000
To: "stable@vger.kernel.org" <stable@vger.kernel.org>
From: bd730c5053df9efb <bd730c5053df9efb@proton.me>
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: dot files in cifs mounted share
Message-ID: <JdUANW_RAsyHKDipLrL4ypuh18Hn-dN-aeoQp74PC-xY0IRNCM3qFY1K636Yk-xLQx80Frje1MJVa1el-fBV-zFp-xCkNwb0KUDLhyqrIF4=@proton.me>
Feedback-ID: 82657061:user:proton
X-Pm-Message-ID: 8de47b20a88e7ba983d2bfdd12c75139ba953dca
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi!

I upgraded the stock kernel on my slackware machine from 5.15.161 to 6.12.1=
6 and I realized that I was not being able to create dot files in a cifs mo=
unted volume. I just updated the kernel to 6.12.29 and I find the same beha=
vior. The share is exported from a samba machine whose smb.conf file is the=
 following (redacted for privacy)
[global]
        security =3D ADS
        workgroup =3D ADDOMAIN
        realm =3D ADDOMAIN.COM
        username map =3D /etc/samba/user.map
        kerberos method =3D secrets and keytab
        winbind refresh tickets =3D Yes
        winbind expand groups =3D 2
        winbind offline logon =3D Yes
        # winbind enum users =3D Yes
        # winbind enum groups =3D Yes
        dedicated keytab file =3D /etc/krb5.keytab
        idmap config * : backend =3D tdb
        idmap config * : range =3D 3000-7999
        idmap config addomain:backend =3D ad
        idmap config addomain:schema_mode =3D rfc2307
        idmap config addomain:range =3D 10000-999999
        idmap config addomain:unix_nss_info =3D Yes
        vfs objects =3D acl_xattr
        map acl inherit =3D Yes
        store dos attributes =3D Yes
        printing =3D CUPS
        log level =3D 1 auth:3 auth_audit:3 auth_json_audit:3
        rpc_server:spoolss =3D external
        rpc_daemon:spoolssd =3D fork
        spoolssd:prefork_min_children =3D 5
        spoolssd:prefork_max_children =3D 25
        spoolssd:prefork_spawn_rate =3D 5
        spoolssd:prefork_max_allowed_clients =3D 100
        spoolssd:prefork_child_min_life =3D 60
        ntlm auth =3D mschapv2-and-ntlmv2-only

[printers]
        path =3D /var/spool/samba
        printable =3D Yes

[print$]
        path =3D /srv/samba/printer_drivers
        read only =3D No

[users]
        path =3D /home/users
        read only =3D No

[Publicas]
        path =3D /home/shares/publicas
        read only =3D No

The client is succesfully joined to the domain and the shares are mounted w=
ith the following parameters (redacted for privacy)
//fileserver.addomain.com/Users/username on /home/username/.Documents type =
cifs (rw,relatime,vers=3D3.1.1,cache=3Dstrict,username=3Dusername,domain=3D=
ADDOMAIN,uid=3D11002,forceuid,gid=3D10513,forcegid,addr=3D192.168.25.6,file=
_mode=3D0755,dir_mode=3D0755,soft,nounix,serverino,mapposix,reparse=3Dnfs,r=
size=3D4194304,wsize=3D4194304,bsize=3D1048576,retrans=3D1,echo_interval=3D=
60,actimeo=3D1,closetimeo=3D1)
//fileserver.addomain.com/Publicas on /home/username/Public type cifs (rw,r=
elatime,vers=3D3.1.1,cache=3Dstrict,username=3Dusername,domain=3DADDOMAIN,u=
id=3D11002,forceuid,gid=3D10513,forcegid,addr=3D192.168.25.6,file_mode=3D07=
55,dir_mode=3D0755,soft,nounix,serverino,mapposix,reparse=3Dnfs,rsize=3D419=
4304,wsize=3D4194304,bsize=3D1048576,retrans=3D1,echo_interval=3D60,actimeo=
=3D1,closetimeo=3D1)

If I issue the following command
cd /home/username/.Documents/
touch .foo.bar (this file doesn't exist on the volume)
I get the following error
"touch: cannot touch '.foo.bar': Permission denied"
When I increase the debug by issuing the following command all
echo 7 > /proc/fs/cifs/cifsFYI

All I get in dmesg is
 [ 2702.654271] CIFS: Status code returned 0xc0000034 STATUS_OBJECT_NAME_NO=
T_FOUND

However the even weirder part is that on the "Publicas" volume I have no su=
ch issue
cd /home/username/Public/
touch ./.foo.bar
ls -alt
-rwxr-xr-x  1 ADDOMAIN\username ADDOMAIN\domain users      0 may 21 14:57 .=
foo.bar

If I boot back 5.15.161 I have no such problem.

Thanks in advance!
Best regards,
Dave.

