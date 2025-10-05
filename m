Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E1134BA52;
	Sun,  5 Oct 2025 10:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759661197; cv=none; b=AEWF3rDspqLlhIYBeBxkTMpPlg/KQzUhUzOpwiZXqGcwTKY3Xv8mrU4EDSTcP9McdMZwEJLW1YH1u5eIfduz9sszNikn3OaNbomqNZ4tiAQ3mGyQ00uNWGV1931lN+H3/PLhLeh18GNIYQqraZcMsUCvGmGTiRZnE7vNjp/35Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759661197; c=relaxed/simple;
	bh=ibgiTC/0gyMqxz9gqTcs7EmeZuC1hjQIZRxdCOSo6g8=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=TXprCO+pG55RBhHO7vvKaqqecswDywP+isBIeasl5IJRPixPGla+X6TfErTvANGwQYO7EtR7DwP7DI+TggDSlWn7vU0Sy2P8kPa0z2Iaxc01podTbV7bj2YAPpuTGSCC5S5rQG7eUJqc1bdBFk/qcnGjjw6+RUu1lNl/mNSlt00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=CVj6q6oh; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="CVj6q6oh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759661158; x=1760265958; i=markus.elfring@web.de;
	bh=ibgiTC/0gyMqxz9gqTcs7EmeZuC1hjQIZRxdCOSo6g8=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=CVj6q6ohdrWPR33g2QqfwbsI9fKjA4mDRVLXl7A3tvaNhrJLZ1jCRnEsDedR94rD
	 HthYHKIPXlS1l3a/qvest5liAyBsM6A0mxGTrQfC0ROmXh8WFRSSijhPnDGwMVg69
	 Ua4pQEU1RPLlUi3k0bOzNi3d9XvUrsbJSD9OcuClYhwr31guPUClaKnXDBEYCLI9b
	 dLbAngLQqjC1GQcfuZXFAJv3v8Tk1RHlmABgmRfsq89LeJYCXLDqZL05uiFw6G/aO
	 vi/MLZycbdIkrOTLfIPc64Z5VDT2HIPOuMh8qGeyRm0BTnhENd+eoswQyRNituMo6
	 3lhzOwuTYrvHCbiRMg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.233]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1McIgY-1uZaKw2tJc-00qIPh; Sun, 05
 Oct 2025 12:45:58 +0200
Message-ID: <912d867a-f08f-40d3-bbd3-9ada24f468fd@web.de>
Date: Sun, 5 Oct 2025 12:45:47 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Fushuai Wang <wangfushuai@baidu.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, Bharath SM <bharathsm@microsoft.com>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20251005064952.4056-1-wangfushuai@baidu.com>
Subject: Re: [PATCH] cifs: Fix copy_to_iter return value check
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251005064952.4056-1-wangfushuai@baidu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:HcNq5ylF43DhOx12Ng/pj9JoHLLL92uRRvEhP2aW5RzvKzFzjP7
 wyswNv8QxIC/kSagQqEd7TTRouSjxg1KbZrRBzELEiyguN0KLD0AJan2aqXR/K3cVMgAKiI
 gzs+DGCcVVr37Su3Bsl6pemLqUAQn58Hr/kZS5n7xTN9pQKQHDeO4qU7UNMOdTsy1vJhqiS
 Pc/0+1vyoaQ/qwm9Vnt0g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:tIc3Sn+wu1g=;eTBDZROqgtpky/u77PQBdIGD949
 Vsr4AOFv6H/9dltt82HQFhuBTTj2YxY1+YLopjJ/3ibGtk+iu/gSeBtv5gJYJKTPeAwPYTggM
 6rG+3OxRMot6B9BmK5CQLgRoMjfbdsXAW8MiXQ1KlqO8mMvCxfQGeYEAxOplgp+oFPo04PZbh
 +s5xcGboMBj6JL22sEYPxs++y4vH70Xcz/ETKCDlYO+wMF5fXHkNyLCHlmlUC5A0bZrmctU3H
 vQ7j/z8UwRwuRBmfZ/Xc+Y9N/p+8ht5qchct9ddCij2qru+FnnQf/S/AttLxfoZGdzl/e4qfQ
 pqAMFhW/OhZxQiQtJb3iC0+NulDfYoqgUsGSS1lqXww2m2r74t1R7/sNKBkrXKAIaywSi4Nq6
 Hc94tdI5AnG1HuniShY6xLS6jd8k1IpUgxWqd3kH38gG5ZF8x4FPA8HMNAzBS1eMAk7amRGiX
 dyKsz43wY4QPK72/mWEdD7Qq7n2Y63uOnCufkIJqwS9800jpM8gAY2scFRRL1QpABDKwe2G2A
 i2okVCz2PfE6xZ0yJKVJjM0ebX7cGTXbHq8K6JkwaTr8aEedLKbNBn9x+WcTwemdMWsy3pAbt
 FKnFYGDD/NGIlu9cK2rdsqJcPfPyURK20T17p3JuOMyuA84TQ62vO1ItZEv2+pI5IG/6m/m5C
 DOhLoVgyNQudIitWqim0RusFqqImjFOGyevXcPvhJahxzeQ0wm+r5Nc7guow7yXdTdqubmjHE
 sZDoBhUeYvDbnZPaSH3OmN9fqv2PjgcViXfuDKBikYyAdgIIj4axW99gAQHmqdcy+3/naKiJ6
 O7NRaSeykkAh4jWkflE46YxzIQi9Ed7T97qf75lO2FDSCUfNHGjy7hJQhfOcVsg8Fvyh0tFNR
 8mbhoYRTvNyX0ofCILFtCLUCuCCSFPbbZLfTMTpDWV0N6OtkeRJWqjdDXyk9dzyhZ6pGNQf98
 pdDusD2Zh572nXZnwmPvXX3lzEjFR/GIUCYn6YXhvkCq9rWarGDLLZgMJKJhTnzNwi2taRXfG
 eCALv44bKSoxyWF4IvKGM0Zf8J8FN0NHlOteL5cSzx69/H//M+HoE01y+3jEdHhZwnZoGnt+G
 B23VNFb7FcSCM1y/cXWIeKwg6ASiRdzPg8HfDyTg/HkELG+/3D2NKhEvO0gbPVz9Z5gRoatY2
 Mrf9h6J9GaOQN+SCpMb/eUHpXU33Qx49uvUUvzbksVFA+ZNkD6D9aBSvWx+Lt9/4TpOF2UpN6
 xw35ZFibZ6HnzXX04QWmADfDDP3MrBhKasA2NS0tIY9blcnFc8DsFQoTUE75uH6VDKIAXWY/3
 AdxN/qn6ybqepQF0RUlxlEyi8E6uQ0l68D7/o7bFOyrGfJQBNIRPhx8MUs7eX7jU72tBqf2dp
 Ci0nvHRNdU+E/MtzrdSEorOYuksASzNgE1Q2R+On29diPIwO2wLG+nK8eFYSN0FgNZNUOPCut
 bezoVqmmOYA/IAsxjplNboNpevWzf9cQqMMCeSCRNLf2IJkFpfiQhnyu5YS3a6lgh50a+6N5f
 JzgJv0B+EeyVbGhev0ej6rrDDGIodwP6cvF2FR6qJ5bWcsioeYm1NZ9QrAcZRmOq0/QDvAEvo
 nxfQTvv9eC7rYRKkakdTK/OXqXN8sHPbsRAcT3jGfHap/vn/aKlD+gC3kSjlag8kpiyktJU5W
 rB7aTt7VpUzJ0rDGfSDf2jKBOnlNr3rl3gsk9RdWUYCM1Ud7PTmKJT4VU7YyJLMbtxLsFdUDv
 jeXelXe+KeCbuol4m16IQf1B5Sy8delGhVZmj1K4wteoIrgqyVBqjYLAbdXtjzq0nmSShMXu/
 /YvCGCts5ZcfbNy36Y/asovRUVMH1fMi1J8AmkiZ4vyVvz0Xgv27Sm5Dqv8DZxMkZJy7qD91j
 lP+Jy7zxNZgsBau++8CwMOvVNEetXHdRJ2noUFvETGQUxuA6xubGRvbp80ThIO/Wr1PWqGI+N
 /MPtvAza/5UkX06/G5YHYRZA4n+/CTS/hgwbZDh3RaQTRPEwme3tRlBT+aYFQTpagf41NMDAo
 iWAcNHsdALQ3lPhFcV6h/DG3C0d0XR9h2zBVlsCcv3Ajb5h0ladpI/+fBMrd6OR2cZhaLwvm4
 qx66jIE6IBIZ9wgl+r1RNKbhnLFwWA09jshPmUXVdx134RMzb3UpV4nRz6JUPB7DSRkt7HSDk
 SB3iK+m1CbUsyx4NuuUsfo7jXpbBwZoi5khHNux1U5mXLUqq1CNrepB5x+oq9+A8ixcSynBBC
 s8Ys5K+30q5v137MC3UrN68ZRp10Rkf2w9FGOE3AqerJZr54j+sycsRI1USvn/EbdGcmKyHNX
 QgQlCWP7dTm5iyNqtTyhj9NTzMTnozO7ZudZRP+8t/SK7qdz8DC/JXWAp0BbKZWjcWWBvOUYC
 R3xOVLUW2M+iqhs2vJgsl2icKoFjQPFd1uOhtPJ/DRekRWdd0RoFG3HT9Ie8uSZccCYxemN03
 U3qHxJ8d9RW64roTAcfSZRfMINaVHDmhSOD8x6SO5bQ+igrxM0+5OOlBSH0eKrheEclLAZCjb
 Ste5Hcuo6EwHIIS+/0iBd31I+JIMDxYyvO/eqyEs4VAkKxiB+FoR/XXRMiVf2XHbeXuqd7R5Q
 KCzcv8xACLFKMv51SsKtZ7AUtUoAC+RV0TixYKamu30YmxXPq0TcfZ35Vgg0iluEpd2ST40wK
 TB7S14w+ZMIaRAv6potA2cS2kt6+BM2IJ46Fm2syQzFAFc/Qr8HjsfDVWLhqR1ngrVncaF5Zx
 hc44V+Haho6Gcj082byMg0yOXo6B1KMgdo2EMD7quuZJLUG2fIPmUgY6YWMOnoRaAYHmydK5p
 xzlmjwqIzW6WVrjiDRvT6Akl7ZIbV4ZED1OveZdqZVhcGgllZHZJy7aBl8TlRw+ZZV4Xb33ll
 4BpAFcPMXltkbtL2hZOSBUz+2k/X1m12bUh2nG3EUTEiJ2mHRePC64/LmPqOzohUfTB4ekE43
 4AWyL/19Z0Fav0uMCaBp25U7fG4O+UcA5Hoyy1Fci96bYyRD2c5qJ1/TXRi9b0YQGCo/FVW3N
 DeXVaTxwg/l3kdm2BH2MWhLzi65cP6oGoA+aR9RLJ9QHGYTSljwHWHoP80nVA0jJNPQJP5yZp
 QXJ27EldNRl0Nedc7wXjpc4BkemydZuYZ0UeSlLa0Q1Sgy1APiDcw/lQkBtk86/fTUcrIKGxR
 nZhlhwV489qjvDQO3LzcL91AA0BUb0NrNLr3ZLWj8UwY/TUTqopar/r+MLDDxWJclM1JW5hko
 fgAkSGa50HpETFpxoUthbCJtARdXySm70cNwYxBjeKNozuuvAxqYWcxlhbLS+fY1fBjuixc3E
 3Ao4Kf7jGiUzgjK+TXtRrpgzDwd1j4ugadi4BEW/ijZrXtoE7E6rc5GUKnX3tG36OEa9WnsT7
 TpU1qYN8soSTcTKAZDKGkqWPBN3WmzcEzdzt2F+b93OPHyhntgLs0nFS3jz2sOOq9QtyQStkR
 oHg30XJZgR3cfYz7jxF7sVNMGjn5dZj2qeNYxs2pcnSnBPQrwS283/q08L4LKO2Na5QkOstdc
 nP3aH4U/34B3904rzh5QgeDh9XxIdPd86zxFKF7Xz+E1j6aBIinkAJNFtg7fO7l2OCEoB0JTD
 a0mfSu7PbVdFb3dPVFCzAlJUw04RiBMtLDYsx8Zlbw73u7pRT+axlKCSnZU93Q5IzePMZ+mzq
 QpNP3D71CMuli7zwYdyL8+WGos1NdK8SPdUkdIlZVem2bq9a1QNMM/dy0QJRMEc9Ofeqr98MC
 7u5jschIGxNnj2RUBLZ8JZ+iMPJ9p52LWiOvru178rXEcb58qsPOUP/9oaHT4iA3tbnsCOzH3
 KAIYuGGV2c4lqG+SjTrugI5uX9aK5BaDLlJH/6G/9wX/xG3Z+bA4vJrg1k5rq555mTUwr6kt9
 OIHEvZtTiJsk+5EjtFY3qPRD9uWerri2mAEiPtQgnACeoZ1DlH6yiPoQwvqJwzm08e+gn4qyV
 Kzux9wO0FKz6vHHI175ZPM7k76Qo3UlJxU0oZH98/wlKUQ1oznipdRzCwMp2QPLdgfxP7Ybee
 i8ZQ9YUQyd8C0rQA140bdVYVJDOA1XfocFakYwIN7rnEmIxs5e6NHBkeDyxZQp7xZ1OeVUORu
 1hDMKOQ3HCBDFBDw66hEEJMhQykiGMqoAF2YVIWf2MQ20Ok/tN5Cw/89LcmDeltT5i8K4GESm
 DiFOdTCyxcq+wmROJVpghvSoYQhldXD2mYWkIvQjBoNrUzVTLoebSj+ASAHLdUIVpyt5l32aQ
 CFuzPdzz0ATsDxPGH+DG2wVNDVEnXrZmLM3CWE96zJUCl/0QhNZWq76Q3az1dTwQJwBMtFVC3
 T2z5tM9v2h4EVcZwM3jbXw6SdISiZWgamtvSmOD1o2ISFNZoHENY6u+HvFCvqi+A0ysnfTp05
 xlsnnzS88jVJF3w8235TKQuP0BBcZiIvL8coa6gSomIuNNQmSuF7M2cuX3zxEMteXciaTTwzc
 4OBh0a2Lt5sAUWQvxmry6h/2Msfkn1AK4Ss+M7Fh9845nW+Yxfw0o4aIP+DbWe2SBs+JgNMeN
 2r4aL20Kn+iKZ2I5wI7d2Sh42kh/MHSDkkp75wHatCT/ZLIEF2VWl7A+zjFsoz6SIVlFnnLHr
 KX9anfk8Hkq/MuH+PS2q7z2KOSTvx+/b0qfOl7RurSkpqH2yqEGlbpihv81a+nTxDvlwnBOeK
 O+MS1xvRFcABB8AS3KF7TFX3JXXLuXM1q8wu6tSImoEgLWN5pR2i9l8CPmzXY4I1hnKBbHWQC
 IirqsLn07V9PyhOFSX212HoH25o94bbT4vSheyp8FGS+GyvLEzVjeDrcwEKvY9prHClV3p/cC
 coqGasdqojpKofLCNfYqo2BeRYiTG7udntuaPLA6JHAxQV6J+OXpBV0Ch9JrOpIu4HdlT1Oe9
 079QYOIbfjHnUKSMbi9R8pmR26dnX1swzr8lYKewgdhHqNl2dttDRLJaDk5JAcagsqDPvGA6w
 ufe0rg3to17Qipj2T6UDXcmaC9/Bf3CmlXh3dk0hs2X+RVtjBXwa5KzMPtYYirSu4Wv0OGvwl
 V7MicZDdrP5QuzV09L6GbqAPa5TQqx5CXqlJjZZx7V63+ll

> The return value of copy_to_iter() function will never be negative,
> it is the number of bytes copied, or zero if nothing was copied.
=E2=80=A6

Why do you propose to preserve the comparison operator part =E2=80=9C<=E2=
=80=9D then?
Would the condition check =E2=80=9C!length=E2=80=9D be nicer at this place=
?

Regards,
Markus
