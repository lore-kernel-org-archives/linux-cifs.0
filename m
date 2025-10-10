Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796FD1E231E;
	Fri, 10 Oct 2025 06:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760079111; cv=none; b=R8R2796ZcEYgmn1Lj7F8heZVFDGJojoqnZcb+JLtAQ9/GCcoc+gsW0+jEJ/akP8gvcwv2ImynWQxUyd87MQhvnmXp13iE2spBYe22Eo3/6lhG7AOcuAQIjSar/gOZJCnWhTzoG2vDKSBCZyTPvYcf2h2j9jIPgKRXvAXvy0mSfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760079111; c=relaxed/simple;
	bh=EKf4E4d9jYqC85kwDTeHkwcH5/FLvpvYghy4JiDj1tE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=KjkZZKaMYCmNgeB9pKFRzbHgdu7PUIVLtJYc/Gfc8OCaE7/UMCX8gK9QplvztkWeTknXU+NKkfznrtjNHG6bPm2vDZoe7jk4izvzmPy+3ACgChdIthceMXcvVuPKeocVl6IWd5pJRmuklWuwS29z1WzLD7mlUJUUjruFklOuB00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=oxlqWe9c; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="oxlqWe9c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760079099; x=1760683899; i=markus.elfring@web.de;
	bh=YU+cG4oPGJIlYxkYFyaad4V9zA4pGvWCsGmGwS2HYPM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=oxlqWe9ca47hXbdioAT0cgqZnoXlUhLPQhLdISpRFQ3CbusGiN4cSvXVUKwIQ9lj
	 PZsQvMvZBc0yHEUuMYO2DetjMFdsWhIOSY9VeLoPW2LHkVPbFUURvvCmmvsz/OHXy
	 MPUzSvJB3PwgC9JYDhG7/WBv+m//7LzfyY6xS3mDuSNbb9uTWgOe7XRslKz19n1+S
	 HfSvVYez4NcLMMKayZzieJPnQAuEOgjKOJ3iXgUUnZN7AGlsUKct9bv7BujBQgteX
	 iiRAkLNrtsa63zKwBWwTHGGFnaOilY7A9i87xBV50Lv5DH6eUHQRtYsjfQGqACklS
	 wnaDCGHHdl3tb+R+WQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.184]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MSZI5-1ueoZm2FY1-00PwwR; Fri, 10
 Oct 2025 08:51:39 +0200
Message-ID: <8f7ac740-e6a8-4c37-a0aa-e0572c87fe9e@web.de>
Date: Fri, 10 Oct 2025 08:51:38 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH 3/3] smb: client: Omit a variable initialisation in
 smb311_crypto_shash_allocate()
From: Markus Elfring <Markus.Elfring@web.de>
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Aurelien Aptel <aaptel@suse.com>, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <e8a44f5e-0f29-40ab-a6a3-74802cd970aa@web.de>
Content-Language: en-GB, de-DE
In-Reply-To: <e8a44f5e-0f29-40ab-a6a3-74802cd970aa@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:jTEjJW/ITWRakBkbMB60LMlkxhMS6X0TgKTeGGpPrgOIitDcDWy
 PFScFI8YFp9Q/rKGWoG3pWGG7+vBSSYn849cujWwgCwckSZQhdmas3TcPeHvS+iUttK09CB
 xxvPbavxxNEnVtyXabCwlqjwGd31KffIB9SOHhjoxtErv17RvLrEJPEb6BAxrrs/M8+HZy/
 FUy4PpZpi9V84y8aMzycQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:xmpO6l5Gxgw=;PxwRvO0Zg4Sy4ROTRMRJYJsMF5Q
 sp2+TnP3rQWtW/XBe3QEi2HdxClLAaaNb9Ds9zTxZBdC1VWETWRBzXoqzchU+5epwxIGxHa8v
 ulezQ57bmgBscJwcIsi9nLEynNdqIwSt80Ke7jSHJrbxNJ+HeOlB3Czei9YdhgbF77gHfHclP
 X9mNh3QEqywvQRYMA8fMfMEx3qksr7yCxSihO/UE7i72GUQEnTu/UopVjzfedM+Yw1V8rtFRU
 swHc4fqY8KSvwuKuW+xypNwgdGz3lGV3ZBFs2uzyh00teNslkyrRDAIBMoov4Qpj63c45ss1j
 aSqfB/CaxWk/YAlWA+itZSqO9yFcZsm2g6mxxjdZFfasoLxyxnXSX2j7wtRkJsGvYEj1TIktx
 gEX42PmnrJ5+gdnih4G92q/kcGfa4L5N3AZduiXDbNO8SIOQbIvCPnPciZwfLfBnA2TcSquiu
 CUmv/FoPBlJ5P5fS+84M0TSKfdG/X9QKUqG/veNayxVXoKY89J0NRSagTPt+pKom1IC4mDkBS
 p75tn21S8GZNbgzGrSotMPTGGKt879BKajGK4XIje0G3B90w5+kYD/JrpVVJ06NXJ1QshT0qK
 Zdd7Q9hkVRNHqiiCEFI9OAsYYlMN1nwL8KyhDS9Kdxbckx6vvjO94miLUDLQLU5Gum4m7DZS5
 RECaR4aoV3v+KTE8ouqOuBD54MBqLi43owjW+zzUHBGwgOlzIxac+UluyzwTUfqKMG3nwSjBe
 1Hb+JMKzIH95o9ovbkG6MbqVs0qzHkLqSJ6CLi+A90DD5IP1JnECQS55PSRQ4a/9NRY4XabZw
 GJG5pHvd0XuwK6mF577KGGmJzfbVBxIKjlvvk9R2aRDy2c1xrucNxN4J8vffgl5/WwfzTVHrU
 xG4U6tDR8gaEjLyaAd8dmcpMGh8JwWeN7EtLGxDeOnVG24ZwQD0ZQNmqfYapuPKSPdjee544J
 YJRx+xminI3o5oL9eyPpTDNITf4LlAEPeIaYf8QgyNP36AJqs7u2okNVG8y83HzaQaXP47TjH
 Wp0aHwUyf/EvnrHZw7afa0M+xwv8XTVtR3w1R9s1qxzPBWvNs5CSkoMsyPMbXHg+rW5S7ppMO
 +eB1UeJvg4u+LlykK9bkKbiFASvTx7wkNlNyytmcqAMQgdz8HhlSbso/kQFMqmpjqq4ZalOnb
 UErW7xEaTycPROAXBfT1VUF6M9TZ6nGhT+rPthnrQlvYpD71A7JhhijZfurcE7qxpEwUABVoB
 nbUVT0beNTIgLd/zKgHztE9DBNfN7ZZ//G9Cru7tZ69ljieqbxbu5bEjp1HNFjhuxvyFcqv4E
 C1slZdbKJq6oX43buvTSrIauQZNNUZey2gXf7zFqO3EkthYTU2Gr4m35xJDuzsP0YE3WJjR5c
 lHc39ISIwambeTfWUl2KgZyEYA3PyV4LbT06bdIub64OsBN1LAl+BTzVZj2iYTIFHyN0mSc6V
 B/ymFbMDp6aGq3VE9c3IplvH8FXMpgTE2YebWKF6wpJhzlfntayXAcgzTi6QfDWgn8Wv2LU32
 eWu71wZJs0OoYU0h5WFFLsLOlbAEMbauTuCD4zLmmCGIabahrHvSmQidR0aPx2JqMW5GhWc9Q
 NiNzfuYe0tbqBWa0DyN/NJgFWDEFhjpxcysAhsUct+9fN+7fZ6GE6xAjb8Rw7y58hguNh8FB4
 tndPjVuSD2U0ikWhArLcMkVTWkCSNfeivvC+52BNNSOqj/muQMHDJ5ckzvP5xTWjirH5W83VL
 ucrR3S0jehfd1GfocWbtYy0SAKDLdejZBWAijim5TeVYw7arAyDaFmRJ11y8e2EbDzngBQU9p
 0d05As0CDC8Mcf4Lzk0Tk3oUmu6ERos9g7fq4CIeXffCif5ybKPkqb2uurHZCLk629odszjua
 8nEnVJiCSAVrw2U80lryinWO2O3h+HlFWjLkHv0HbiSU3Pb4TBLVAOZuZZJkfUvPUp8ZLlUdl
 gKxpAOtBx9qgiuamBxpx8J3zHP4oOqiw8Sfx0gRLliIZpaN6lqZqWAszr0DpwCFvj4ckREvqT
 taC4t1PJQxY30B703kE7LCZB1mf+BPPOxUg5nxxu/Omi7xI5eOS8G5ILFSzX21oaIXuPReq4k
 yMr4ZQnSxeXRw0ovlVGIFvpcDg+zeHme2Ni7fENQiCbrXhGylxLGv5zyJtgjGb4CriCzc485u
 +Hw7GOlvwpWHyHQZgozaVtkIoA98PCJ7yvcwWtmZuizRTYN0WYGP65/FQyPOM6K/qakDCLXj9
 Z3e4+PCpfS8g7VsHR4M9TgRCghrHzAakKtBH82orU+fho8/LrfX1xFv9Yt4KEF+0a9ZF6lm82
 rBwbott8ZhaHvQ0c3XcqAnRnKVz9j2MMw0x7+8thBjdkWVWKvzfdFubY39ThGIG5t8NzihWUG
 urMnIPH/5zvMNh22mMfKI6sSwHHZIp42iwZ497gLtDtp+HGm2EM2d+bvassb2jgsAbEqEWCCf
 X7kj9EoxYJ94rtmZOKqzepPc/2qES800KtBxJzEnlEFGGoNeo4QNWyKFohmiDSYXmht8F/FzI
 pjzO3OK+6e2KK91IJ630aArE5JaozzS0xBwmQrSaCkWQ8Mdz0fWS6kSxUgndBHan5cvv7snpW
 ldIWRx1kndFnUe2umNdlDJKiNY5wbbB28hrDUlq+YhS1H2ZsB8ZtgarWGROV3a0Q/rqanpvoi
 2KHKWAAoOsL/whSm8WSPuZ6JbsEYOxZ2Dtn756t58gZ2qnbQp3qsvwP9ilBuVJ85pH+zDWXnv
 BBwZrfw3GvuZwTue+jwcPsuOF3vQJgtnghfxN+CpcLH+Xfw7FlLvA4DDswlEXhsAigyicafyl
 ABQk3Zeq5HDnakuyIeiNcaLRCQCHddhQ+64dGmpuPuUe+G2PSelpOGVyh/wdva+ZzwHtiCqF9
 JwNEo0cMrL1ee2XX2of1HIHKrXa3kOheVaSznj2S9tpwagy4+ryv2/kWLxCmmYo1zya45v2Dd
 d0Zh4b0CIt0Gk8Xku4eNjPvO2stlkL/m55krpI3p8QzAOKyMUr+8A22zaMHs3wLghyzBMIaay
 c0vZu0Rh0W0k+pDMtjBj4rQ782wvB70QvNhFsdt33L3rxinl4buBlCdIqJbEan4fLtp33DVU8
 OZvCqjt5ZBQZxyeaB0xfRG9zAO2tC8gT+1MdTx0WFUl81XnbxporVC0V9vL3Kh9TCJVR3rUAB
 zbPTRjxKGm5xT5wecgFaGfp/jIC84kbRzLIa/8PAC0XfHlS0r9ypjdKmlVXw3qUjbdZQ0x+09
 8FeusLJgDcrmn6BRap3VPPE0ivsqn422Sp6MHs5Juf++poGqBCsFCDEJd561uYceLNj3+jjku
 BzdEm2uHRveGO9lKpzucSu3Ni/Xs8t2u2wBlHF8WHjst8lJJ6QRd6EP5o+zgVc8uyF5p65Qjn
 GQ5v1OZQjkotZMWFhZooIqKbWXXp6TJI9FM170ClNaAfR6N4pzRmS9NSRwRDaArW6OZBG4zi8
 iL01UQcSeIN/dW2Qe2z07yEdjj3oD2/RCShfeDgEO1Mq4imUf7LnfWmHpyN1XQvyRQTFuqPAC
 lk/aOIO0kVTKPP9KXWa98YZA3FvsdalwYQED88zxWK6oGjTH5LnuvYqdOIfkCesnhg95z9KVU
 QQptOg9b9WSTVUsLO4eoTT9UNzsCyclB0aJevhMQbuSCJkpkCf8mzdmaeYDOnqfB1kun+HMiw
 od86Njy8f0QSFvqArntnBYNdKf+ZOSdJsaSDmldcO7/oym6NVwnM52YQqFrpAjvboySj3m09v
 fUrkQvUYb46fKSX3IRcH7aRl+r46Msgk88jYt3Cy8BrkKVzz82wYijDQr1P5/VSKjKMoBNZ94
 COupjVvRjdexefEwlvIjr+okXXW4T9csTUGp1TFymuZ8IubRX9wueOlERDIbEdvciWOHSWb11
 vaA0I0rdHTJ0x68ZJXXg6mXs37q171D7EH9ltmc+KNuzrNosl+NyNeYkUEznmtt+2s/WJpZkf
 +h+1FPJq6JTIHXSZYGPESMBo7gFDZh++n7I6KHhSknXMeJB2pNDY96jUCSYm5QaB7/1kablMp
 RGnvkL2B5+YGJ9sox3vurcFJDzDqOd6GXY6TwlcKwykFqXjAzrS+BOdGaLgmG6Hs55bKKFQlR
 +zpzSotYHrqsEdC2eZa3B0BNau2Ty+IZIJPgH70ZsDQB41fG8Dq01KXcJhfPRnLz9gWSKP6xA
 c6Q8iPZYnYwK2ABdyISiOg4uUJvxxGDVJmmhRKI3vty0FjxBgqR6dyFN0zSw33Wz0O24FcdwN
 5SPhexonFgpbO7IUOzohY39n5Y8lGBu6rXtyfunMaGTBIL3HVHpii/F/Fqm0vV8hlOqooyPDl
 Cv1NiLKh8F1fRD0yPPmi6xsNVsLpbzSdguPvT+Ry9t3yaR1Tq8awgKyyrQ2svTZuf13Zdgslo
 SGRRkeHyq1vbXaD3EtJxI4O0yvsSr1oRpmxnWuQVDjwIynD+mfrmcysCADC5GlTBNHjJ1dlR2
 xL7BpIZw/trh1rZSD4DZO1xd0BpHZVDuoBiYi5G7kVa3Fm93tEmvDMikE69Xj110OReCOYaMH
 8LvsixgeUcsnMJTVl2BQkuTB0qpay84ZU9/1fOUn3r9IZr6aKTf/osK6iCk1pV7jZO0y5EWM3
 qdzxgLhNsOewAlklMxmZStVHJ+tP+tQvajFTu8z7cdvVBa0ImwCsbgEKhLYl9EcDyn+QXHD7y
 0gItK+oszoSdxtKxGc3rgI+F1rwNOj7iGGNqpX6y0LzvgVcLw6+RlszvPafRnc4jLNCurD1OX
 uFGLgw4IZI1gzhfXyD5QHm51ioGUKGsh1ngBXTBkgV/vO9CFJugSkyff/Rgz0/2vxJPSB++nm
 zUZeEA6dsAaPBG0FnzWD1WjrW4rnug6+AKHa4wjboFG15cump5jEc6b3+iZDkmcB/bC4DR0Cq
 WNJhHK2FpGT7m1mx/Gcr+eWH/t6siTjg+9klRP5D/a6Kz7VP6kGvWbW3IPLRizBUj1ggcO8Jl
 /zFgAmZiJ+JcN6OD3/mre/jt512wkVdS0/On9BwdG/AjhUD0/4CqDSyDoTS9pIaSaNJ4gD3ni
 Vfg3RVmO9OgYU6lunPT0Ib9Lm1xA5qcvqfb/x9FgeBI7EFv52wuQyusEO2UZUd5GdYy1ZvYDO
 AK8lNrK25KVMc9v7I=

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 10 Oct 2025 08:05:21 +0200
Subject: [PATCH 3/3] smb: client: Omit a variable initialisation in smb311=
_crypto_shash_allocate()
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

The local variable =E2=80=9Crc=E2=80=9D is immediately reassigned. Thus om=
it the explicit
initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/client/smb2transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index b790f6b970a9..3f8b0509f8c8 100644
=2D-- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -50,7 +50,7 @@ int
 smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
 {
 	struct cifs_secmech *p =3D &server->secmech;
-	int rc =3D 0;
+	int rc;
=20
 	rc =3D cifs_alloc_hash("hmac(sha256)", &p->hmacsha256);
 	if (rc)
=2D-=20
2.51.0


