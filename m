Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A014414;
	Fri, 10 Oct 2025 12:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760101001; cv=none; b=U1M3p5cTx+Tsv/lbsO7D1oxlsBcNywrqUAqll2Dp8AUWozwjDeRjInd9TFcK4kNxbwvq4BV0Ovw2Xbqlmb6MKXG7a8PrU+geDYeSwWoEMA62S1LnETNT1rq0hNuMgVAQt2x9WqNCJctcKeaz1Y3MngrYh8YdfXHiKSq1osOJVXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760101001; c=relaxed/simple;
	bh=dD3igITv+JHDtXiWzqDlls1b5ftAr4cPy4acz3BAGhg=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=JNCUNLvUpBUFsMYmAXeqmsdQkElhvffBWANd5X2xs2pIeaKn/SWYOfUzoUI31KKx48NgoJnvdODpCNctC6318Kga2Iuo+jz1uBBSeV19mYXL+8/AbEoDIey9GnCap9nsWccC9BafMoTvLf94V6jyVGC4JHml3jNMowjVqaTJam4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Ixmkdfes; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Ixmkdfes"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760100996; x=1760705796; i=markus.elfring@web.de;
	bh=2SNKVWEp8lysblDMfyyWDhUGHiqupODtMa0SLSCv0C4=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=IxmkdfesMykOibIC7wP1Qz2AqsM2uzwpKpTbML0feW0mPKFcAQkJG4UJCIPTE6pN
	 GNyK3p6vm3gI1utC2DKq3rLmDIHPjZYb7O9FF2Y9OxgAeHf5lsm/GTmJh+BNxwhqK
	 2XXEyT9qugnSLeYxDO08uh5GNF0L1DBDWH6GQewg16BqOepExdMkW6nkk2CkPgzA5
	 M0mvA+iCL0Vx3OTGfcR3vBKjYN9P3E16Cz/GYGkkrszHA8GRB/oUtKzZTOMyXDgxb
	 l1VGm3ZP9NxCMbdwEmqWKVlXcX4+TpdqGm4PoBL1uA5W+u5uvxX1+CSHnten75+Nf
	 dI6Rzt+MlsCPNiLCBg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.184]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mcpqo-1uYgru0VfO-00aFLc; Fri, 10
 Oct 2025 14:56:36 +0200
Message-ID: <10e2a3a5-e109-44b5-ba3c-3e8c40d76361@web.de>
Date: Fri, 10 Oct 2025 14:56:34 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Bharath SM <bharathsm@microsoft.com>,
 Boris Protopopov <bprotopopov@hotmail.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] smb: client: Omit one redundant variable assignment in
 cifs_xattr_set()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xgGFKwlC8fAbNPnPhe9WRoYMzFBnzrQvqKFb0p5yK7sXTOUiC/s
 2XYyLbz3901nw+YfYGSTpJwWX2XlydLtKWPTFqnQH6S6ULL3uACcMCN/CQczU9QFc6DRr2U
 PXo1WeXM7vRWcGH2Ji5vV7hst5BVKwrEKYoMbUDRhEDK03BKiq2OrQUUU3ueCG8W/XFXmYG
 4c7yOdm/LRFUS5yqD8AlA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:eW8yYte7cDM=;aIZaFF5QXWh3GxyP8Yz03LbE/GA
 FAPPMnCtnx1swWKjKnYphEEkmU83PbchD+9lj897d7IxFchUB4dqGv21PCALIwZ0GRNYO2OJ+
 yo6wsJiWoPF+27vJPGnlOmIfaLwaCHmZK9cNUQqb0qqzfRM0wxLViluU+Yhy5gsGHU6IuyOcQ
 8s4bNQa22DB87nqRGsCnaeqBKJNjATEtJO+GA/Sn2P1wUw0upyvM5ZhdFoSp/m/eLEFUaiKCA
 RfHUK5A13wFcIwNlZNZZ21RiYTXv6kXZVp2cdWFNgCa6W3R1xPOsG9KOpOxI42dNEOr1qOZ3r
 gClIV6oVHEzr/H5TtMeAEUzRbfgXtp9Fijwnp4Hwdb8d9yj2uAao0cNA8VWaFBQT68SjB05pK
 oqtMfEPmCmQB6NAfRRnoUt3WtqZcQ8DxUoAnuvtyqizmXGNxk+FGf7j9sdVsidnO8PgcQVnCY
 8W76mjO1/C/FBs0ZWAUGoQR1vS5sE+RwwfNkc3lCbedRqfJILqFbHjgbarLCoOy9qwy9hYcN0
 P8AHJ67nhTS2NB+YnB+FySDgD6TYBmOmwr33VaK/kihdeY5VNmyLMkV168xdMFPP0ztVbVZ3K
 kdNmEiNNqd3SwgrzBotutwkqrnAE74ROtjK0m/UGtFzyrqEw9trEFc/VNEW0jATwSe5w6qAqm
 JeRrGwTjnuGRGvy3jh6ME6XjOFPxyq3QVWviJqprOqSA+uV0NQvE4WkAKhXgBlwD2Wr9T5Nmw
 +6pWnGVEJm+5ZXoFPRjKEZS+gA+LYRmOLNzMmNZ0q/NY59n/0N8W55ifNokaH9EmT8O65kHNK
 WLLUSjynvoNOVRo/r9LZ9ZDyOKIi4d5F8wSt3IUmosL9BJ7N9IhRALsmgE8kL5PtDytBwbrew
 VcfER7AUvwEgQQNzSMUUtBr1r/171xpai1gOe0J6iPdjhnxdoVFOkf8VTUq3/+JlDzzJZ13WQ
 YjRYfkbwdWo60J7pRfkR+4YQhGESVWlfyIXNTuKj1t/SyBq/U3VH3SMicjIkGtI/yjq48/ece
 cyHXxCMBA0rZ5v+MnFG+9Cz0WHIZ1XWKbVlfsjey8YgHh4UBSbr6FO/z70isfDNX9ZtdkIv6H
 jKYITeHlswLwM7Y44nT5vgjmwgDYzQga+BCN+Y+dXwEl/1soYDCyEWRjxf8SrAkFZGB8Cu2Xb
 WKdhj2x0oJUPC8KJJJnJrgmjp0xaNT00bT1xYiPdHyU99T9EvGiJUsVMXLE2Qt00yPei3M7m6
 m+cR/VPS6Gygpje9H8aBlRR8hwgzi2/hGVYYuz4l/KqrLgXyH6fIUgENAtXK0k3YVWOu4LIJi
 zC3u2SqDJPEIEDCrMmX9amJylNTbZYyGmQjDR82QrMWNNghI8s0QX4kgj6t2uUvoQQDEpiluD
 OGaRC+2UJiygMEKs0t0jhjhqkuCORKMEcJL1CFlMbzFK34WZGoL/Mt8WQ3raFmkS6dcn4oUU/
 sHmKadwH4abCPJI0cREOwnEzeTrbwAUrWTVtWC6WYHx5r+wQh+H/7dQP/honCCPfrtlPx51Kl
 G68jXOwRw/YRx/Il5nSPg6UVqBStCOhtjjM2QEB4RomY4snE5wb20v32SJd3MUhTtsrQUJK7x
 lszQnNZnXZopmaMTFJliNvHwOzHspGeKOfZeL/sKHYQzto2qjR6m1tZsyP5DyIIXeplrSDGNp
 Uz2YyX+Phkfn8qxuAsdsO61OueqgyMlii4PmguE7IisulSWB8Tc9toDcNRa83Up+1i6JsUeO9
 va+Nhoi5w7NegecCvMGQooEqi8VaGWnka9g2KGycYQh2ggyS+C17wPSeJV2N8D/pKfyrlv2Iy
 g7d7N3W5xPN9LL284fi/zO/SXf0ZAQTwk+9Q+Savw4xYIJN/5xOpwKxPIVj74iY+kp/2wO8iW
 K8TjmglfksorrXtQVqh1nBpOVqWS7GM19813B+owEcq3Owbqg665BQUPqCdwMiMmyYpM+2qnO
 er27tahSib4JadBzrw3YHBF09WmUqbH883qQosRH4+uOfklTUNWokT/gF12Dspyb19FpG8/JX
 voU4CqU3qPDQBywVNoISRAdkdYf6NKnK7cj0srPUnkX+bT0nSXQT43Zyo9xTHnKXv1r1XSSy2
 ard6ZElS85c5mDwVaof1oqM2/Or26C5E46BTT18fJvAHO7Msla1NuUyrRS0uaAkGfp/IAQdaP
 8xfBXLFjtxi3p3/nhrEyq7o6/rrOLZmGlbRobp7izoo4+Fl6UB49kl7PQApQZ8X4tMyWjcan6
 S8kt3rscYZJNzrmYLFIb5biCG/6/RX3kVXr6gLQTVHRT6I7+c5yzvgZ3ZTXry0GWs5Gj5ergH
 SV5Zdl9XT1lkSGEGR7aPu+qoB8zcwIpLxKzPlfBHfFygpbXcwDxGh2nCPHhQswuPl8cCdAJFv
 UDnyB1+jMXR0YOPtzYj8neMwxkrv1/n7LENu68Hm0+SJ2K2WyZanpX+e4AAJ9wz4kLZa/ibhY
 bAUTM4f2vikUuaL+sg1qtkuY+j6fgwZPH61I3oVsYZaW+Hbxf5ubF2XE48rK8mA538b90tb8u
 g8QToCDV3FpM0I05H6zDUxyAcc/uhr+JAuUwuapI+N6/AQOdX0KxUdf/6+onYa80ZXrtiQQzn
 WjdJrI80HZC2zNbvnpqh/GGlE5y2KFSZDzf3V+/m6oPkLfGEf3k1m6fDBy36fQyBDhY8pXFEH
 y8mChqCPHtO/X2AUTw7DTrg5UzTS451cKmv6FJ+k+oit2LgSyTq9puH71PDt4b3NRzOjT0yGa
 i9BPSVEm34BEdB9O5UZqC6lq7gZfdpX5nMDayGwOaODzBMB5OS/7ishpUVuPFe9+Lj7cH0RzE
 cugMr+5dLktWWzPr1q6ZHZ17JWDd+32HFwK2yMHrUtAG90GegoJldEFtB8GOjPoJK6OVcUGeC
 iLnGtDB9LBzFb4K6JEDEGHbGgQey8lrRETWedh7kiA93TVaQn+9N7Rcr8ffk2iChlhN+qEv6p
 bXQ5LK4+Zfjswo3HhDzbqLsy4+yoVRsTZU0sGkoXiaEFKGm1m8MlNVvSBNOWCjM0mkmu14dnK
 RhG4IOa4V8k7kjMp/WH9oZ6IaiB3DCLzQeVr8BCz87c/thzY93udKZMGr4H5K2cD/aABho+wp
 02bL7bjpG/i9tBxQIuYlTOPLK85W5Nl1YhzUB7fwSx7rRQ4UEkzbtMlzSZonKY7TAb/I4e5g5
 AQA8tNQLTq6YXAfR51irwaiFvd5PpLFdxGjUwnpLavJPflHbKB5CfiSTGKRBF4GrKRSnt4Nqk
 /UmxkioKeB9sB9tniyGM0+AzoXmPbclxXzBSB1VVMCPmzLhugYsFk9RRxzEoDUNwPnRxPX1Pe
 tP+hCr6OemyL1Jp8jFh2/N9F21JsHhF9pYLNVv9QRucu3WmiEADlTjLwU0I/uZQbcgpGqjL80
 AGNwcTqRfV+Y35znodGhn8Dmg1RDq3fWog65DY1Q0Wu9Dw6uGzgPfSa3B5ScQ83svsKiceBIW
 rBbCLLKkgqmLxHAkzrjrkBt2SLSd8m/PuiCoSyfHWqeIGXngcFu5hOg7MyOdp8DTLBuf5y5Aa
 rhgc1uwQHG7JrJS+xBd96e1mtljh0ojaIc1j6oSjYPWLWLrLgATUVc/UEA0Rb6wCCN1TfR56V
 379T25sYvLDcB5knqO679ge4unlpJ5plg0kPJZmlNFK5mmckrNqlVXz4VFU8NyjDvzmpWsWSZ
 dnMdSY1KOEvOfCZiNJhyhVJ957yAQos6WDExdCPjNuf2WbLHZpxWXPjRazvxNP/Tmmp29yaR+
 MdXZSnjKTjq/dzCqVwgt6wJjtvpg2SRvkj18zzkhib+ZVrRUwA+CYIAwyEa/VZhggrc0fTIiS
 jx4VuoO65ICQoQOU82WQyatLZcftDueSk/vDDqpaK/OCiuBvpCQs0GL02ppz9oExbt3ZEY+pH
 PahQeomz+GYP/NDWW+CTXNJrFaBgHZieF8FjAk6iafodfYADnpaCKweiwDZFEHY9Quw8Fqa8+
 S/pM0z/zI19g7XV+ygJR2ccxy0vLsFHzXQLeJsaT2q8HsCMrRD/to2exWzCOaEshPR6O1pYqU
 kIIvTHGXx/y352FsefLM+Jbr+4eHYgfDshVrkevkvC9O8n4/IZqT8u/pU/1kMgh4nEy3INR+o
 XvZ5PUF0AjeYVaCS4sXChNQwxTt49WF18xoATOmKWpLUsMqBgS76oWKJ/t3G6GjsLpJdR5rZ/
 Cf+eHKla6pw5oAmlIZcsrwHOgBp3BIi5LH6wZigeC4rGAru60G/ekfmCMaY0kpKFtD/IfA/9j
 jSER57uWWlFpCCT3K1CSeB128OA1gIauMW38poMjNb91ki2lYcbjwbR686z+KjR8KWvhhbn+Y
 jk3Z3TOvEg/Tn/MVXhhm12l0GvZYSZ8IogDFunl6ugi7R0m6cJrDhWI6u+SNRFtS/nJJ4kip0
 ACMv+zDFhE/ZgVwFgXM+kWDQkLWS6oXa2Jl7m4rwDjI8DgyrPbjWXyxy0eJxzyy8IUfxfAMZY
 CProv0ax6lO7B5y/nd4SLI1/bfKhVUUEVfX5AlZb5GJlZAudSmLifp3A5JcM+FaUD+k1G5+rn
 CL1ShOuxOkzW4BX8Cmv6/vNFzh0rAk66F2LaRnfO/z26H1FwN43gbUG4QokkLYsjbuxJTTDKE
 R7Xf457GUloTplgBu+dS75G4U0sGh657kvvaSO07cEDiHp+rZ5miJ8nqz47YE2oA+FoFBxB07
 yMWTXac7ZYN/pHR2xkMC165VRbosnw6wpNhlMCn1yNSPf0kOxdgeP+YSZaPMgAw63Q71zJu+Y
 myGZE0ChIeehhEm8hz1+G2eFakjh6daTvWpjXOtMDX/da8Gi5R8yL3zrQmXu7y6xLPQaSYjq/
 /28eYrqjvEQPzCthHFa8r4GVpt90cOK71QE+15wazUmKqgdJx31x5Q/zYLp7iWar1Gs1sxGDY
 jOLwgqAlervSaeiFoP2VcmEFo/Ouvfv/5bN/mKWHfagVtPorh9Cj2UeCJDQn9TGDC8AO7e1kn
 jEYTwoqmWbfocYShOGAum9nCZ8zqEZW76zERyheU64vjYvtpM0c7xgY6/g2qYNJ8yVQcU2on3
 I1EcDd/1wX+ZrHebJgZrpi3U+s=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 10 Oct 2025 14:48:13 +0200

The local variable =E2=80=9Crc=E2=80=9D is assigned a value in an if branc=
h without
using it before it is reassigned there.
Thus delete this assignment statement.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/xattr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/xattr.c b/fs/smb/client/xattr.c
index b88fa04f5792..029910d56c22 100644
=2D-- a/fs/smb/client/xattr.c
+++ b/fs/smb/client/xattr.c
@@ -178,7 +178,6 @@ static int cifs_xattr_set(const struct xattr_handler *=
handler,
 			memcpy(pacl, value, size);
 			if (pTcon->ses->server->ops->set_acl) {
 				int aclflags =3D 0;
-				rc =3D 0;
=20
 				switch (handler->flags) {
 				case XATTR_CIFS_NTSD_FULL:
=2D-=20
2.51.0

