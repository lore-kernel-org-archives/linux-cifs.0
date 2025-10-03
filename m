Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D93C83A14;
	Fri,  3 Oct 2025 18:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759517121; cv=none; b=r2hgEpSmOqax4HPpcarW1qSBX2ktO5wJANuUjuJyX3Y4sKq//yDS5T44ZUlLiX/BaILhXUaz+dA3TiAir48AJw+55zg35eIVPMCJ11+oguyIyN8co1MUWUMy6YgUEa4IlEyG5h7dKpi97didnh8SWvjsZQkkWBZazp9MypIk+aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759517121; c=relaxed/simple;
	bh=FYmeS6Gb06MOWqRNPJ1CjYqlrGWteugAGxXeLks2CRM=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=MS8vNaTCwyTfNuyO8CfMHIhhRg038C9AVVpwvWqgZa5nQNqedz1jFT/ms4cXNum19YMskWO7LRzOiyf64Jscjcfe2MXCLQ71hTLc7fQ4qBsMxfrKruIoXf+LpenLRyLD1y5K2KbBu5uYkRFEcieGSdeYOsbRFlp7cc4mb/LRzNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=j7nzqRmj; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="j7nzqRmj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759517115; x=1760121915; i=markus.elfring@web.de;
	bh=Mbhe1VnBZaWGgVctyWB6G3RbwRICHnCJjdyE3pzuemU=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=j7nzqRmjwDhbKAD0ZTWMMGrXYPgDDkWR6sWxOh/Y4iB+SdCu8oWRkg7+R2qtDeGJ
	 WQqFVnxluTXqV2M8bL9xVoRAeiT2wNVelPv9sFifP50025esQIfGSGdY0pVEWRlVo
	 OczpOdf4vnlgfkFR1VVhn9ozA4k4juBc1D6kpRR/6HdBD8nwFiW+aNNRqp9psZE1t
	 AcC0vdOkSBiWus/BT92BU4BFKDRmElcefQhCaljxswOzKhfcu6Y+C+f1OtvrgYops
	 hwW8DrwcDjEFlBRWHeNw0+uk9+uiY5WlYl/kxrI11/MBjv8+HStQA1aXixqwJowHN
	 2Io7KTPIhnrymfN+FA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.196]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MoeY7-1uTm7O0vO5-00dIaZ; Fri, 03
 Oct 2025 20:45:15 +0200
Message-ID: <6d759211-79e7-4d86-b22e-2ae46d209622@web.de>
Date: Fri, 3 Oct 2025 20:45:13 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-GB, de-DE
To: linux-cifs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
 Neil Brown <neil@brown.name>, Sergey Senozhatsky <senozhatsky@chromium.org>,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
 Stefan Metzmacher <metze@samba.org>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] ksmbd: Use common error handling code in
 ksmbd_vfs_path_lookup()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:OceQ7Jz5m7TG/IeHF4OrUJjhM/WokL7NxM8UBYVGRuj1YHVkhPA
 Y2/jyvnPKrQzEpQaYkR8HPmXp1UybrwLe/pHdymZPxaIfaB1DCEpWn+Piy0Vcy4QrwutYNS
 rrvnWOR/pcFrlb5knrIUg+vJ1Wm0fWxy4CUTavHQ6zRJOGQNtOHgHXepMwWyTwehsak1T7a
 qBqRRsUeIYO8ZXZTJWibg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:I4v2PP+XK9w=;z7Ggip63sEm15WVoeJwIafJ9fS4
 7nJiiF6Gj+JObuE9BpZv/+uv8FrwL/i7DGAT+oSXAkls+WreWCYNL3hq0MjHPqxg9qebxBY2U
 pIHgh4DAMR+veHVlSivwledpgB62e1plSOAmt3YEBocOrmeESSLjO1dHU9H1xGwjQ0M28wblp
 //q4XXT+17NBz7K7jZZN0I5KBQMG5bBWvOjpNjErr9LQueak8uOPSejQaysSlKRyhD6Pb7een
 lZWrIJR+PaIrpbDT1Y3oDUd3EPGCBh7xQP1bKUqb81mTilJpex001S4ALnfX42ntlml4fujBI
 ReAhfbORZlIV8NQMwN3tEwyvQLBwYzu8nVOlsAlHAhwb4z51cCs9XRacXS5r5d0aTuv7fkFcG
 Xi5r6Ttz5uGWMIMh4s09WoesdPdjKoOdToyZCj01TkXx0j6U+yZAPAcpKEYMmPP9Zhy1kN/t7
 WbdUM6kcWhOQhFHLN0HYBxLgDHAFnoU+xNIzR8qqbrvXaVt8veP7y41XEErqCKB6p1gG7cgzz
 QKsFaijSB4q/6eGgpScjF1oJgE7uQZcfaHxFo/ZDsj4QOujHGJEvWEAQOSO8gMnuL8ePItD30
 G6xgqMoPT57mQdJ/9NMUm5FTE2oqCEcq3buZo0nuxQGgq5sR0k6nkkrbNJJMkVGkCnm4/o0Mo
 T2PTysWsvjyRhgWm5gNzoLeF5JROzTwxZWvHtZvFSiS++4mCU8zu0Ew4lz2R0ik2WwVk2bj7v
 430Wle8wcdacQTkI4BNgTTQ6UTUnnPWpGSnZN7URKomO0W4c/GREMF+BATav274ik+ZcBJSD1
 AhPI8bTRZqL26Cel79DuHHQlCVXI7eMj6Me9/BfnsQ1W3DT7CT4NaRXncb+yMIevahy+cqZ6e
 E2ZfXlGmRoCVH/lAfBqRzZQ7oHcIn+N0NQpLXd9XI5o+DFVnCPa+cjXcE9S233lJQ8lzdDxgP
 ZJx/mZQixosFNhqjhyl8gsLCwIdudsSEQtxYA8Q7hRNsiMxmE1rKH12Yzn18BW42cLaRntGWH
 UnsDbQDYM1f7DcSepQpTQSmvK02fuumvtheAr6CrrXkZ8GACjta8LrCHmisHxF0Z+1gRMgmYn
 ep3kBjhv8uVoClFwH7bujU0VdgYCSGunj6oSVeqgU3E75KjmWxVdpiGeNEOo5dWyFyhjeevD4
 ge0P4RAEXaN4BmZFRA2hIvqtRFbXqPNVEv2g0qCxOFrSRoxSMuAqkiT8gCyHVtnTmixjJ/49p
 pcCDUITSfnFwN1HCB4s/PyFau744L1JJcT27C5MaxHVAahVwVf4J0Ke13fs+JY00rjsW9DlVZ
 lv9RdZ2CPE0O50Jq7PUoH+EwVisr9xAd00qVlGWt/FoW+7+0zOqp62D7Ofom9bWpYsPqHFIks
 iVGDLsZag0MBcotEPrKwqUbVOuYDqHnYL1/+Hsnq1dIwMFgYi1n+MxD+BHlN4AZhSB7SjEryU
 GtM5SBuKumaS+F0QYh85vQiJeXwQgVcGbdWiguJjaCMdBNxgjb8cI7stjCFTx1KG/XPi4mYuO
 QxkwU4HZ3ms4Idi5AH7B5kWQgmrK9vMwNzwv4NAuSTXoWMZ8UZxLq1w7g6bdzV9EaW98qVCVb
 gLyhFK6ztlUIZg1KAMH8cQr35MEF9hb4wjMCFzZran4tGfIJMR+DoXiO3aOut/DKzrNBAtIRn
 NWTogxBs0CE2ULO68E6/fh4+ME5BLLz4vldR8+4pPsUKleV8Fec7RV+6Bdq12julCy4ZaNfHx
 JLuWrfwwHt9K4cn80xrg4gofUIcQQ8gZIJMP8S/MjtgaRdra6eqo9PlZxE/WSlPAy85VyZN7e
 zyreiSWh1RgQNfCTgkRSd/sVWLdyQ8B9/JNwJa2pW5HKFyBfmd5XlcQ/qztjUU/o99j3++Q9c
 hUlF/Rj8yxUTlqsahn3ddGTk0xcORBTr4xyX0UdXPRJHKcSTgYkFFtdvk5wzRdAjq0KwhQM/u
 9V4TEBvHhw9/IkRKFSTPK5QzNjxAyCLcg8qvU6nC6oxy2gWmRmb7l76HLCeED5avSRt4Co+7v
 9P5cLzG4FJcXQwp7UKPdc2Ujkn9Ij3kCHBk04G3cOc2gK3tN3NRIC4vh9yyPNeWnVQTKVGSaC
 LIqV2FPq3E9cMqnGlsafNioC2/2ErZUkMUTgRnDkwY1t62hlSEy3tynAqeVG7EIcweHU339Mt
 JyGabi/LdndUEoL8s0/3KYSNMMB2xee3F6G58sATPdDOmoDMUT5d/TG9e0JDF0oUpeflZn+D7
 wrS80VXbxahgT8r6B5EdH69PG1kDy5HXd8/Qkl6zt8kS/OxIgpbLx7GziHo/YQJUp//yqAA3u
 BpDQ5leyVzTnFDLK1IynEMh4ifwXXclvy2zZoknRSdn1exn1h5wFAEOocpP9X9YYE7C1stMHF
 kOB0/Z68cbrlCGy0Y2atj2F3gCFGv8amUeYgZaUR5TK+jatUSgQrczcrqko5BF/qtgsnpghzh
 yAe4mNRk0I7acpLVqpKzuH5wDW2IxJR7qTPwqE5puFXg/r/qMXofJQu3m+ycG6W0x/wDGk67/
 L9Sv69p+hlK1iZ8QU/1r5/c8ZHdXtJ7TFIMLGUESsbOWjQQdYkSMEYarv75RLpLdbVR1Kc1Cb
 YlqdzFsaruYixjXc8lHC/eHiTaL9jROKj7IKjMc3UKhz9CFI+LDuhiv40xEaaNyuDf91uQpiD
 btAjPYLBKoUaHHMY6aVPQX1f2aJ5uZOSsOzzuTk5nP2upTCRdJCUG03VSxpAnHvG8DSdmCAgH
 JjRLigGx4dRbPzuZ9pr7HazuSK2e7gsHi0Umwc7OBt7lfz1tE0dE8hRczHYfr2+I90H5ogbMS
 KTlF7fMMJimcpXALRmxpLxFPTTIbCL4Q7Rw8uUXXi77nxD28ncrO0nhG/hqFn2wEMHZYj/lwg
 PhsOOzjcYUEmaLwU7Xw2VaDnUS21QaNtzDUI2xEj3KO8U1PCA3BD5AFXWbUTgzXdkms4pqWuK
 M3v89nG9ExX/l+d2MXTDP8j6n//83YLlRQ2C/fwgPCNlwyaniz+ktJnq8loUW2DbH1Zl+yF1g
 RCEHHO8Ez9jDOFwyiJWn7I8vMbNY6lfIjYbdfdN99MfOd2HmapgphOD+s+9DHhkMS60fk6vMl
 F1B3MLO6QoYBYPNgjyKmpAuCXZGq5B38pTOggXkAAr+yriJXqx0wF9RDYCTeCRyCzdAs/ELvU
 m7Ft1//kZoPAjgFHxS5DYqc+kHOqIGHfGv7TyReVnCT1tSoLqP3xaK3eqbB8PvUt6nZbYY9LU
 Z6NYG7w6RbJxkTKPkHLu+PJp66EgeEnJwjbZxogy3ftxFo+hGn5Zmp7N4QC1yYZi15XfQnB74
 Lvd9JRGWqYK8pIVA1mXy/K6UEbqe8IZpQJS5HRD+LPkElpAMGUOQ9afpfo8WZFNRALN1lXtev
 kuFYh2ZfbYBGDmncTQNNWGa1+a+1pk1TkDdksqCQjVvNVTCgvQTLB0v3OFDYEzVKFnJhcp09X
 lJj3AD8VnWfLCnJ5aiAjiN11cJL0txHdnJb9y9nWbwP2DzdBfHX/xVmafb6hQR+DWYfi1Fa0G
 7QtF9wztOG0fpWoGRHFrroy+UHvi9RvxJi0jv9jmtK9z4maY/S014xa8mkDLArrGsDl3aI5oT
 mGkXCUENRQZu7vkQrPNXtK8bRWi0jKSsqEJyVJo+k0O/Yu9jOGd6QBa8qO7YS93z/HwlS70GG
 noLj7BTvfAQerF797FLb61riAu9YXbq5UxRW04m/Ro/bRgTyByyAEb4ysyWPwvzQbbrhsIJoU
 41B5/q3T8qDA7IhGyw/KA9en2BWWubViruzh5Aw7tdjDotkJ6TdEFY1FAW8j7SncXDynWGonY
 AQbFsM9NZg25MfGtNZelzmhmxYwHiKixvoT9cqbQ6K4CfW6iqnkLNFH2NIIJJvGcQKuYFoIiK
 sPqaoVsBEbrnw1e8oISLiQ3klUfKIQaaAehyBHfb2GxLrEsI5rU6j/scaZDJpDSHrIkj586HE
 QMuBUX2zVJYuart3IpW/8Q6uh4aLqVgciBRtXmYbWvM0lXUBnwfiYgkG16I/NDgCqgKJdQLPe
 DRJAnkPrF2uBZcUz7u6Cc6C13QuGp/7oyTOq2cecE3PRevnnkIQsReJ2FYG7ppQ7kn8ptzqBl
 yIhWE4vDebH8x5975gjBTwh6fmpXQ7jo4sJyYQ78ehrU3ce1wSqJ2FIAiXhTsm3DlcXD4GlCt
 btfDdeNabjgck3/fpt8xTWVn72CEqYkiS8pybgLkLT66ClZNzWUTTd+zZpmyTwOWLIvlNaacS
 qMIbRFKdyrRVMB8GNsaszLO+m8Qpbq5j0qwrO4OYtCtId/dVK1Y4QGhNA8hp8+qCqLM418Ct0
 hluwCXtS0sTt77Ljl3LepXdr62CROFb889PxXIgXoUcS1WZFUN4Kda6SjXS6FFD3vO38qSGuI
 s6iIOj7PjlinE2qOGAZgSBae+L43SOS2rxaGooswsm3uw+4zYAsvK57uVyaoKhK5ZcgfYAfV9
 3LdxasUWscNEl4PI2df1/stKfRlfmMwKZss9hivAK+F3bhgrhbDk6GPRO0IKn4fxK7Ov/ggOC
 gmScftzIC6okvRVhRBLRovTidVyW5bwB/sLec6+3os7ubDldpe665w261xV7cS32nD5X3L6F3
 U0XSm8rx5Czj7sX+9DunN7q0x5IngmMS8DV2pC/zEz1IifPPstyUOdBLlOT0NO0mCY3ExRvdp
 MqYoXIlMg1mibEXs8Z7mx5vMSrf/YDe4u9HYaqzN75wJjgeOZu7Y9BBWtTHWXPMDnj2iQl9Wa
 t9BkcikT3MEY3WJUA2sZ7kM/2HsRRFbAnPO98xUTBjUsvwspgOXy1u8imhApe3inosSgW32dQ
 mRZNCChU6LHZ2NCx8+iOchKbSRKBctnW1YZWGAZtsrhYOS71yniTPjpS98i0YDI+0BFkLUUy2
 VH59E4NpMdbmuWgJxIV0LOg6gVXTzOz3gTis1eIimUwR5LVOGya/zfMKBRpSeXq62SG220p1b
 mT1XxvcqwRk2ziczR3txalGWcXTik1KDLJL2z9pcuJT5xZoc8duW+IEm0d2PZeI2VYomhEy83
 h76uKPFmHUxNXGKrhpGNanxA1M5lGh3JVJi8VpKk8Z8wasw

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 3 Oct 2025 20:26:56 +0200

Add a jump target so that a bit of exception handling can be better reused
at the end of this function implementation.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 fs/smb/server/vfs.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 891ed2dc2b73..3535655b4d86 100644
=2D-- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -94,17 +94,13 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_co=
nfig *share_conf,
 	if (err)
 		return err;
=20
-	if (unlikely(type !=3D LAST_NORM)) {
-		path_put(path);
-		return -ENOENT;
-	}
+	if (unlikely(type !=3D LAST_NORM))
+		goto put_path;
=20
 	if (do_lock) {
 		err =3D mnt_want_write(path->mnt);
-		if (err) {
-			path_put(path);
-			return -ENOENT;
-		}
+		if (err)
+			goto put_path;
=20
 		inode_lock_nested(path->dentry->d_inode, I_MUTEX_PARENT);
 		d =3D lookup_one_qstr_excl(&last, path->dentry, 0);
@@ -116,8 +112,7 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_co=
nfig *share_conf,
 		}
 		inode_unlock(path->dentry->d_inode);
 		mnt_drop_write(path->mnt);
-		path_put(path);
-		return -ENOENT;
+		goto put_path;
 	}
=20
 	d =3D lookup_noperm_unlocked(&last, path->dentry);
@@ -125,21 +120,22 @@ static int ksmbd_vfs_path_lookup(struct ksmbd_share_=
config *share_conf,
 		dput(d);
 		d =3D ERR_PTR(-ENOENT);
 	}
-	if (IS_ERR(d)) {
-		path_put(path);
-		return -ENOENT;
-	}
+	if (IS_ERR(d))
+		goto put_path;
+
 	dput(path->dentry);
 	path->dentry =3D d;
=20
 	if (test_share_config_flag(share_conf, KSMBD_SHARE_FLAG_CROSSMNT)) {
 		err =3D follow_down(path, 0);
-		if (err < 0) {
-			path_put(path);
-			return -ENOENT;
-		}
+		if (err < 0)
+			goto put_path;
 	}
 	return 0;
+
+put_path:
+	path_put(path);
+	return -ENOENT;
 }
=20
 void ksmbd_vfs_query_maximal_access(struct mnt_idmap *idmap,
=2D-=20
2.51.0

