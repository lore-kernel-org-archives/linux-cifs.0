Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 170A32E5B1D;
	Thu, 16 Oct 2025 07:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760599335; cv=none; b=YaEgItiF9ycTCqiYjCi/OQ9gQRhuDVC5J0Y5OEF3lRaf2dIlZLT5xcXg+UxsEOUfVIGM0j2DLqEmcTt5gg7kAXMVDgkcfh1LddDzHKUPdloK4dhlpXqQg92oGfAjDx7siRZkULEAYt6roMdFrU7tRTBMgcXFsplWIxTWrFIH844=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760599335; c=relaxed/simple;
	bh=C59JgKvwWWhUInISEqbPzJA1b1DFwSmcGjDq0Nulje8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PHcqhANNYhFcSCYgHsLENoGRK9jnRQgqrsdDgiJSesk61tq8Pbgi1d1DoPyNKXI+Ur5/PowMHu3tCZNOZmKm3oEPFYDRl8Q78LLy+l2ua9lA9fa6YNlPoR36P7+x1CHeWv8DGFRVt7LSyX6MaNTROlRjpC4Ktft+JsHdyliI+FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=QSA3J8fB; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="QSA3J8fB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760599324; x=1761204124; i=markus.elfring@web.de;
	bh=ClF/lH/L2hUjaH0udbSfDPG5j9SaktaTFd5cW5HzLTg=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=QSA3J8fBq4SRPRa9EiMGeavZFncmqvWw6uIQr+J7lPEaqD+e0rG6ahOkBIXRIZLu
	 IXRzxA6DQJNzX9gxptTEkcDjaqGcu/VYT9evvrg8gNHxSNrVBMlxKj/j5BziXK+fg
	 2HWwGXLzrwynQrsDdCwIcCwQLzNvJq0N8/96r/INbY5WsLcq6i93bPkWaap6gP34g
	 zVXZQbdxAdEXYPiO3ZBabjFzXtSD+g6X9hb4/Yb0eEKABrKWF0z/tfNx7qtQR9zI6
	 3K8iB9WXIDH9wvkPmbK99k7UKcsmh2l2XBoqA4ws6sbhZn/JZW7+hT2FdvSd6n1+b
	 fRhsV3uhzwh+ybTLGQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.241]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mmhnu-1uSqIE2VoU-00e1uU; Thu, 16
 Oct 2025 09:22:04 +0200
Message-ID: <1f9e946d-91e3-4f9a-b26c-e69537cbbd4c@web.de>
Date: Thu, 16 Oct 2025 09:21:46 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smb: client: Fix refcount leak for cifs_sb_tlink
To: Shuhao Fu <sfual@cse.ust.hk>, Steve French <sfrench@samba.org>,
 Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
Cc: Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
References: <aPBeBxTQLeyFl4mx@chcpu18>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <aPBeBxTQLeyFl4mx@chcpu18>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tmHGRQKLg/BK76yM/sIHBW5q2wuNFogaJ1LFLdCIQFchbHcz+7N
 O5l+hWkWa/rt668xAJKX0haG9FQ7StluVA/titfss0j8LA5JVElGjCgZ9b/GvXf2r9W6nSV
 zanaV0I8NTImmtS9koRHCFdxokaHwvUX83sfq1HQqnhni1sx69fBFO7KR31rnjbmSCAbQhi
 zo+Z0vduXBb3hfWxCXgVA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:nDdqvVZpSZU=;8Ua1uscXuUJEmHyHcaN6R46gWmA
 4kgQJRjmpCm4Ox+YPM6O14AsWYvoa9AvqTCtTMowoMJ9ICaPXJbp/yHlCOfaPFyOKHdz/x5Nn
 BbaqB1+DrakOWGJ+bMOJAes70FbIlPNUpTWareZRg+TRKrxo8jAmTILtzxwLN0Lamr8i14Q0B
 YZ1IwhIwof4tJaIOqKCUJRGrCE11ZJwIAaxcdns/x6h+QVhhJU2Pd3aqtZBgzcWA4VrG769Z0
 CUC900PDw4E/IWbg6QZfxGEG4ErmPWUcCzOIfL5TrV7ZZ0KdwOGpgfLnctZYR+nfsl4L8xEv2
 QFBCk5Iaw1Kwy0qIeyJ9rg5FqyMbVicJ4Gt1+PMBvG8ri7Sno7pR+WpBU3hoHcMU8Y1DKGx9g
 uUGpUNgW5oG61m9jWk4I9y0AMTmMrliltSAwPZHIzNLlCooMQNn7bVK+GujK8bVjVuuy8SQLN
 viJg6vH8K/WDiy/IHnJuAj+5kOUvebmy3JaowVVIvc/hdBb1QAWdpvw+lSIV6d6Ufc+OQ0K1M
 E/pAxxYL/mD48fYjSYatVtYekENWW/8ILmtKJXNIhxOYASgwifPXUGWkwhayoOHJNxidwqgYC
 TlbCvKtwY3Ebc4PyN+zhjB+S37ChmS8rMiQ3FWnxA+99x9WTTdtkVEmR3Jg2IDFxL/8gV+k17
 9ZNf0Fb4VE5pcsZmNP998iRBPdJe7nlUEhPX2Gq3H4SG/QTerUgIC1ZMYrCd8qHutr9yO05uj
 FxAjSi/x6WQy7jBUVkrrLe4cP+cx/YQfUTxcN73WnI8SJbKi7xsBL+5YptbgApAd7gV7G/vaX
 h4znYgie37RllkhI2LIkE/So0cvbyotxlZz+t4wxkuwJjrIwkC87CDTauFxC9PF6uiKzNsoqS
 PLYdOjk+yyJS9Yl2syOBiLD1yTrrO9j82xdu0eKEJOyABTYewpYHsGA3LVcninz60cXPiKqj/
 OTUSud7VOoMK5gzLxusFQV+1manPHiV1D86unHf0Y8tDsphYUAp7C1IJ/Urfsg+0RCEuI0RI5
 QCpMvfUc/ferDFcjcKmbMa54SB93VfTwsc1xr1QUgsWbIUSEEnD8PG4NtMGRrz3CqQOULboHG
 YyhUx5To3jCQOKemZDb+z4e4xZROTqMNwiwngvo7NJQ7cYaS+cwUawVYCfXJnZmMJmpERzIo8
 bC8L7fk8VvURg2XO+ljRxokXn+TwMXPj+LdJFQxf/LHGxewZh94zfDyAvLjb5heKE9AmZ2ksC
 t7er3e4ugNsE0o9pMJ9DBL2w4jMkn/SM9WpnyYQvSztyC0sIhnX2GePYH9UnvAw66QaFZwYSL
 Mc77dUxhs8l7hchU/EOxkwNxoeDv3zGqrqdrqeKKUE7Xf3wpsUCsX10p+TFV8HifnFK0QfUhG
 x5giWJiUx41YyxFT5/A55vB+MKUW5CtoTwmEE0gFntpMoLl4/Ia7xDu+W9hLaQ28mzJm5p4rn
 zL2yxUGcSSoiq7Du29jUF3rWq8WTGriMHloWekILNMznIPLU0EOvQkTEVzED8kZlAsLKq+bTr
 fJTJ52o5G4PKp8jQRpKLvYxxeenvmhDOGUZMGGT/HdqaLss+BTmt2Nos4GqQ66CfMjy7K6RFw
 LTuKZ3olIFGVFK4EA7fg6yex07dJBCii8FJjLBBYWDY9w7FgDzypQwHsjnXd1G/ilpVocDH3u
 4n8jRgoMOgZ9bLHGUUES7Tz8kMfDY5Juv79ybHKmLoSj8lfUJq5PDCvjYVg4ocyKJJM/XnxLo
 ys1nGFsTrDdKRsCEm++g0f+0YhgNi0aCJIWPXm8GxxF2Jroufkgt895vvM/ttdSWD14fpv9G7
 CcoV6EQIrzvctNG+NxTmIXFAX3XJeUw9qafuQsh8t9LK5niaVsf8TPe5Dvk6tmBJRhaQIbwPM
 Yc7dYlA3xVcbtmFHNUu7zusxoLKscI5xGPQxcdAdq89X9tU0ELARjH7l5tT6nIATxWhaMAs1a
 MvqzUbfFQt7+8XeZMfDAyGumuLCzHCU8vPHV5GV7aAXyDpnN8hGgOL5Ng3OX7Hzu15Lj+rlW9
 1JcNtefRb7mckt8QPJjBYIRgOqqoL5u9wVwT2NSjOLmFGcZOjdwb+s3LZmd/o+WBdGNmn/nlR
 jnbV/ErBYZ+dGz7A8YciIpSPC0R3Bs3bGTM1feXzwFogh5L8Lft4y+kcPCyIzwWbzCQtTvgki
 03rVTCTvF7KGPDqoxjfU7emDEucGtKAi7rv9zAXCUX+SSv5hygz4FdqMEs3hjZSw0QW6msHuk
 3xUxWWBI/KrGXxTa3rQeAbZSRpt8W2jr87k/583xnBkZVpfAGjmf+xqyGSVNec9/UfeK0+/qb
 Orb7oBSnacWl15SWjuHpBLPNa7in8WF1km5WzMXBONzO+h+bAQn0K56xdXApYRGMKXcFOTeKG
 /1wUverSvWReCmMVm2Q7fnep77uGqEHFBKeDyQkfyeBxA74fKk1vm+4zHC83CnYf+tdwPoMUj
 p8UOlTL81zd715zLlgcR12J4r7p4exHOEAte61Hlc5uC6eY9GCJf7kXqJzcUlr9Y04ghARg38
 FMG99Uml+n9eesmT/EUD3UnAIpsjKlv1FyDrgZrEliNDJBnwzOXYg/50oLaa2uk2HGXk+x9az
 Ei+FCAKZzy7N88d//YXtDBEdbL1Mw/PkE+8E3DskQQZaojuoQZhilEfwXDa4grjejEvABbkCG
 q2Zf6Qer4BqTmQBfohbYh3WbhAFl5blCeUtiyq6egZ53fA3YECslePVmO/qVNImxfuCbD8gKK
 q7E7KZxm1918jTtzx4HyvwoC+nDOwPmAf2CVc+p9tegKXv7ynfPHNhZXcekx7lep9ZhhuYUyQ
 9pplQ9w3nvbSWUd5q7sshrNMyRasxwVh2FmlYel1kIOZzxEdri7A9ec3ue1DH52+FWEw9InLI
 S+xYUOB6WDk7sWK3gEj6Z4oqOQRYi1DybvjpRs1bGUyM9iN0xN3MRg1o6PcZis0CWsJ3IOar2
 KoEM7bWonlNQc0sqxqtl7rkHabewXAKVPbJK6lQi0ytRN1r7nip9i60Debl+juPakehzICZdR
 C0ZZZbJyP9y/iD+Mp3f42Jg+8YY1fuAFNDlul4JkG725DxskXOElvATLxqpISGHhJ3H1yqIvg
 h5C3/jQnOg08blmAwZqFuY2OI0qsXNg3AG9GpmQix1WLRPrz7W2PwUY2LLNWaI8JHHnPfMYTN
 8U439/LchLhz/ihD+PfICamZP0RDxV7A6ygPVYKB73YTg77yp7nhjC3+r63yVXOGV1hhxfcDU
 I82IhyMk2ELfS80yYT7flOAyBwSM4oKbAYBY08N5eW+iAVCwM1vAjwUwg7fTI6m1BrbUaafv8
 QwVStuoePPuLQk+Q2z0ypC/wZps3PjagbswkNzCwqFFyoUa+HVPzw7QqpK/ZM1PByocBIk0fW
 4Aj6xd7CRVWFA7MYL6mMS6P1uhzZFb3soJKzy+U5agLFc2jeN65yHyNiF+HDP1+aJPpTeyMca
 txZNCT3bhSf+1YGgHTczOUaUwIbUMEX/CyOjFyXQE4yEHIA9NYTC/SaKldZrHOiSSNM5NSPoO
 +Zr4V9oX+q7whZ0bRnLcWA+4+yeMUyFFk085jKlVitOALILo+qGh4yYdqaBL/XtZs6KsQjv/m
 pp8EZ/Bno6kcZuBdJrsMQNDg9wzy0XALuXbFmH18Wf6HFMWYvELxzy24weL7VspR7DFNbRFpb
 r67KfGkD7/VktuN5rOlQUXl0aVRxd50ifSwjLAnYI1PhGVrgcxOxNErPaEiBHgJNYbfamMKYf
 jS7hu8MyPmxMj8N371W+ELPq9+Nio/li1ZWVjkaS5wg8yLqh6Fg5XTDYYYuRSv+PU6B811VFl
 rWLZW2UlzQ85zdHONqn+nAA9dBeTMIndyY2UBOYLWTx4YkWMlp7YPt9X71LKCs+8inX1veVC8
 dFbxvbEHRxXTrpuu3TmBLjBj8nZU6Scgma7xo6pzEkkAOvzkBB/NZZFxv4eX8NubIH3hivbZF
 AdAR/8UZagzT99tiUS6PY//gOwLNcozKtTLNsSpHdqLITKb52mOf/prAPKqBa9+eKOMR8WLEy
 hcHOQt7EV6qGzk+d5mQdS714Nl55i4Z9X9Cvk9QciHDaP4jd5t9vbSY++BIKPklo5BjFDTqTk
 CHEOzyi2crSHCixj6lkPZxX1+12ntKcG9EzZmUaKqVVmFs2ql6oyW+GcaFk4FZsjzL8CxMN+O
 R4YPnpJoIYNGl3Oc+BBWIb0P8MQICuEpHLZ+vHl5eeTaG8K/7cqiOWBaHLqRl6L7BaEVjLOpb
 6f7ZpmHyxax9V0ZKl4hUHF6vEQwFfNE56nA5TUP/kEu4DRmjuUt5EJATgdFfMHq7WjuEferk5
 d13UHZ+XXY4ysWIkSP64N/o8FW0NqDrWv9j99EgDJR+yDRhLYVIZa2F/StGdHn5h3eYtdEgQx
 32n/MBJq+N04BQXv9VXaGqVKnQXpDcfVSSOORaVwT/siMdNjMHPjvs69gvgyQWHcK/Bf4USyv
 gU3JWqaLf/qoLsJjCk9fNMLBuuLUFLJEfTGDI7mQj5cr6FNSeZb7mDKZy9joNb1wTdvJcVzKj
 Hxx6fDuGIDxdojysUSqYPrzPvAUkpJNIIuPrbSZrq+gqCrDwN1PwZ1nXRbXFXD/9bDKIKZKBM
 LhsOVFOw0F4WkL8wBfhJNbQYAa5HcVSRFckLJ57svMlSTVtZ06k6hJQbH8PMnjQcRT8eFKeyJ
 BVkWBtkL+nDkG4j0k6NFKxhIjJ3FzduxQTOiBSFgdTp7xyAN1OHZadwseJSMEjATW1nY8HPqD
 1wfqMx/nthhhoV7nauLrxBbzgNH8Ik1ay45UGf6YHjy/Gmf2n/M/Ecu6h1WBZjj/8ftK0iGrS
 XcAPMuQNhqL/r9VuGGD97Qp3NAlNpZFqFx1E3o19iZbR1gCla8PIu4zx7ulT35Pz7THIyh5l1
 CDu3DPyWG1om1t0xBV87DY+92FgAL0E3aXOOf18r/ptJwu+bcmRasS6L0nzyfzNnamAr7nv58
 DWcYQ0kv8fdajPUDNoPDVo2LFc/iTGTe5e0=

> Fix three refcount inconsistency issues related to `cifs_sb_tlink`.

I find such an introduction sentence not so relevant here.


> Comments for `cifs_sb_tlink` state that `cifs_put_tlink()` needs to be=
=20
> called after successful calls to `cifs_sb_tlink()`. Three calls fail to
> update refcount accordingly, leading to possible resource leaks.

* Can it be preferred to refer to the term =E2=80=9Creference count=E2=80=
=9D?

* Would you find a description of corresponding case distinctions more hel=
pful?

* May resource leaks be indicated also in the summary phrase?

* Would it be helpful to append parentheses to function names at more plac=
es?

* Is there a need to mention change steps more individually?
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst?h=3Dv6.17#n94

* Will development interests grow for the application of scope-based resou=
rce management?


Regards,
Markus
