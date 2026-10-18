Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3012A3DB632;
	Sun, 18 Oct 2026 17:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792346002; cv=none; b=uFltSpZdZru7IrsvRgKweC2yii5c6Gb9e5/remdzZKdnELAoMZAJ1tM+W7QPsoWYwdIYQv7q8BUyyKUyDEH13i2uS8Ue5s3vztKpFf7xT+3FFVfQBBHXLHukUl/OSa1W2biPi5foVje4XmjP3PCMrYT6oo21YTfixNDxQv6jjJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792346002; c=relaxed/simple;
	bh=32H6DE+r9AoU0+4iacdmMKj99U6TBd7KHjGOUuG3xgs=;
	h=Message-ID:In-Reply-To:References:From:Subject:To:Cc:Date; b=fY+veVTU9myUvggrCVhXgiscy+ozZ7KI4uh/sVfrqKINango3eh0c5n+ByfJa2KQwgHTNRBk/SahpyKqlewKg361A70BAYPp7y+OmZ88eWKDYX+VCca7jABV2+je+7dtJYpXdWdvnYDTAAqzDxXTeYJlbEjeCQhWtZ4Q/Go74UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net; spf=pass smtp.mailfrom=gmx.net; dkim=pass (2048-bit key) header.d=gmx.net header.i=jan.koester@gmx.net header.b=eU6uZUv4; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.net header.i=jan.koester@gmx.net header.b="eU6uZUv4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.net;
	s=s31663417; t=1792345998; x=1792950798; i=jan.koester@gmx.net;
	bh=ETjex7HfmsK+BJRJOndPMCEwA93mv32Btn/FJ5pMlKQ=;
	h=X-UI-Sender-Class:Message-ID:In-Reply-To:References:From:Subject:
	 To:Cc:Date:Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=eU6uZUv4erwA+lfFx3H3NtnHg5g65uXFgE5bPOD9XhTbhDHOUC4HOduCooi/0721
	 P8RKcuOT1BdZrY+UyY3iuV6mxXw3C+qvUaiXtRW2bv2rYQA1ny7Jr8FTnqPnxRl5w
	 oKIJ/lnom0S0wusP9Mx8GfV0Slzk6nkSVms1lQH2clFPRlSDx70/l5YSPXkWeh3kx
	 Ikd5MuZSiyUmjxanB7qj1RSoQU227KtlSxsf5v+JG7iKjOhk8MSXrJVgew5bptf6U
	 X/JTdKOpaeeKffY/NNSJVAVYcdJVkSTzKfAN6C050EovTVKHuZWnO94eEWMZMoGNK
	 +SPjPGQYk4UVCOSGkg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from client.hidden.invalid by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MmDIo-1wsH0P3M5g-00aTPg; Sun, 18
 Oct 2026 19:53:17 +0200
Message-ID: <0ab0b83aa71945fc9f4e2711c3e815872954e71f.1792345559.git.jan.koester@gmx.net>
In-Reply-To: <cover.1792345559.git.jan.koester@gmx.net>
References: <cover.1792345559.git.jan.koester@gmx.net>
From: Jan Koester <jan.koester@gmx.net>
Subject: [PATCH 1/2] ksmbd: pass through NTLM authentication to a domain
 controller
To: Namjae Jeon <linkinjeon@kernel.org>,
    Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
    Tom Talpey <tom@talpey.com>,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    linux-cifs@vger.kernel.org,
    samba-technical@lists.samba.org,
    linux-kernel@vger.kernel.org
Date: Sun, 18 Oct 2026 19:53:15 +0200
X-Provags-ID: V03:K1:A037dEK5QyKW/lVX6snVX6wfMwruFZCOxmxAWAd+BspWnMXMcrg
 kBkvnJU/Rn1Ag8Q2mNMi7fSx2eqFrvYJjQrs1GcU7jdl1RNcBE+6gV5fEYweIdYGblPiL/r
 tdiIHFtkRcMd6i87Fb8+GxXue4FNfcLUZ37ibH7WuYL6YTVX5duv8fivYbfbAXXxY4ORNt8
 35PH5flt7RQQrxb6qABBQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:MpjgbVZy3sY=;6aFWZUHM5wEuRFCRuk+JKFMgWNy
 rrA5PTRJMhiffaFSbAgDgJCAeYPGPo6AnoCYKpO0uwCvQ3u+0iPkFz59IuwFjoUYizyoSmlmw
 DiFEnMOEJ2H5tfKmt5lTuiltAcKAwobqstufxnFrB8ccNF+L74y89eRaUUPyT4/z64/plvywJ
 hLc8lK4VX4rzsRSPZw6+y3qvFePyHf2QQ6044grlBTRh0T+yzT1ZVZ1K4a1VCPriDpba9JPB1
 /V+Mc64JUwCLe4Sjm29vbJiYR1g75kjTmKiG/FkcK4yNi8mbuGisw82gYW60sQj0oTDe2GJ29
 HB6tvbMd6rjPkM1gBdZtXrBVOnWRGy7mZfqOsIDs/91pFlu8l01FYh3iC6VLjHN0ihsaYlVVm
 SLeRDyr4NNXNjT6N+67zKF3/9ueWbBnR9ViKYdV94aHbIr6+JKqK7PPAS1cJGaRREF9WQPO9r
 7EyXyjLZPE00RaAm1UhX9cB2D3HjpgUs6XUEm3vJm3sICG0zCPnqdaEEupLmklrlfwQ70acGS
 mNNW7IR+a6t4E8NQOZFj7r55SRk0k3KFwX7A3BBPLtD/Eo7vnDhdF9UslWhK7eQgt2HFxr5ju
 AI1TQ8n8HS7ub/sEwjzFMSewiQEM49aHKLUcVvcpaGHYaEYocaUYajVsx35+lAk6vjd/48CY8
 8QTRvJibf3rHdbiNhI3N3eg9u9hTGYRCVkDEU4j5xfEEJmjNK+BhOe1IKyymyPE4rh3yK2v5J
 Rjj40KWE0ZFO6akfaKVbRj2R7hW3otwExuDI7rXtWrZXWIzK+uxCK2bjFcrhwxmQ/LUXH2Kei
 J9+xKvtcXtcWoMnbbfxBIxbW+0j18DZhNMMfdmqHsa2MHxHu2YMACOLfm75KHeoyR6F8ch/jE
 YwMz9ugKt8nI8lzuT++GfjNQZIDjbLS+LTr6oZ0d9+j7eVgk1CPRG/XLATuwAvNEn7p7o8KTv
 u90ZwKb29xAFaAoON+x8ZGY8HbKl6PWU1YCHVki8O3gezTa8ZlqQMMN9agXQEbdO+H6YgCz8C
 wKLr0F9oKCtD8z7izKsq+5T3Y+e/nDchR4/CHyqGcW0ZkGO6zWN+/hXJdCgJlzcDMEK35BTwc
 bHUdx3eMKUruz0nmJ5yOj9E3tOSeJs0Gj4UALHxekyF3wDhbpV4CmtQDWG2S+j0HEZGssWtS+
 H9iXQyj2ULOw0cUEoDXp13f/jnWLcTjgPKBd0mBgRoG9DlV7cbiWGtrXmZYGDQ9NUBA2oDMZr
 Vh2wsCa5E9XigLhFh2SsalPD0b2P04d+vZh2QujkrAmGGRFuVB9lzxIBcNxZuz+cDu4klADFh
 VDxbhBLtgHxS59asuAi/RJqnkbqswgMKNnqc0HhEVgpVHhg6jINmBDOm4i0bTwq2pmbqa8bkQ
 LkhvJv3Ri3kB4LhzDBPwhXYPsUOzPhnadferNrhgYhgaxVD3vu+qEiUUqhrVuZIIxWEQxOizz
 sTsBxoEsq8e9nN9DNSqXcNKoFZMKhBPXsH9BrUAEah3S58S00AYjqngj7/qxgtmt/hsWvEac7
 NduzdFrpXY8sQ6ZRRMyZX4UBgsMJI/lOdwTRf6+wV6Jzf7SphLrlBHZwqIH142wi7nxzPR8Zn
 8MavX+g6PuFoPZd4hzW7MwKsiwcuuts83cZY/gcSayy6k9AsLaPJ4zUbVsEOYbZ4Ofm/6cdwa
 DdLbGrlsGkwJdT1EkyygCmFVd+pM1DbPeqZ+tHDZKPtnvFq/8EKkCRA4MnpRko+jPi/HoKQAj
 wzEFO1YoaUx2ECUQO+qzTgfEZj0RnhcbrSO9V8RgfK6wHpYUKdl0hofdFIJ7OnVEILxjj337Y
 NxHwS+n7kKr1KANocrPqOPfpFYYmzbNw11ntj3K3bjcW2SQESwsl1N+b3tH/pug3akRAUEiBr
 RqbRFn0+dJbqSzNXYLKgn8JVskNsVlGnXxOk1MtiLRWJdf2ZUTPPktaFRvKGaDo/cv4/ammH/
 4iovZA3xxxjQADJaTuTlkrUDBxbfSnOuMgad6t1kVAIfr8tTpaWNbMgjG049GbcjBhBE0Dob4
 K3tb346g6gNDVYKOtEX8QUzquRoWQ6hJQmkiK+LDRUL48ATVn+0jOl30DiACpIX0PRhrywi/O
 GF60RA4F6VeYMx3R7l3PN78a+0fmrLGpZGbE+FzgAWMRKSFGzlmU7qI+5wM6p0tKzk8LD3J69
 k/YlHNJUN4mOa7JN1JvOut16ix5v1Br8oaApmy0Fp66hQKQELoVai1vx4G1uBDtq1C/6l0u3C
 I0hQcGrsR58Ge22uOeOEJNFHPaXQoUnzM4EkEbawyusfxHaIB1hN4Mlk767A4hvvdzPmMGVYC
 pijOACJ1KDr+H4H0SIfzJeSh0R4Fe7r4hgO1FW7pt+hBIsK7wvWqw8ax4qcTiI+vLX3gGp8WI
 GkKrz8lpgrgRQPYWFKsJRRgOIyyhmKUsTkpPBGDtTmnWywgCrzzLSoderFLmm4ePaE5B88mV6
 kGrEKGAA6Pv8KHrfF1kvp8Z6H8IemHwMAKfmYHwTu6QVauVrR9TWmnq/4Nd6h6XJqxfVhMs0T
 ljxb8HIjQaLRGR0prDYovC9+I0BvndEdtv1/NSD7uWTdpgE49x4vbnSZBDtx+qHt+zrMkkwYr
 3OuE3Yp5fDuh9PWhvzhnd+pgS5rIv2at+aW8QzD5+6YYVylWVayJ01XJVEhqVjQwrATyjTBbm
 u99PwncpyZNkCyzEJ/EVDWv/ZK0NerCtwsa36GH8oL8rzMwdenPmbyWD6EaMtHk2VYhZNh1CV
 +pdr2Muab6rA4tu84/OB2TmMkCWLCc4ry8f/3P1FdMrbXczTk1C3uFSNLKXy5gJRUJ7xQTk6g
 9nRePz/5cDYq/ItWW4d1T5QdMrE7plgh9WyEg4nUxPmn2xgcaRIMvEpJK5Ue9xKGThomZoc/q
 Ddbk6PJ5xV6AKMOoP0UdZ8NJ73/P9W19WKoMDMdrEFIQf3qZF8iUBy0Sy8g1jM4oa7/kFeeXS
 2wHDtrlPipjFi+x/K6+4HmSkobO2j3szegOcQOqOJAvNaFVkJXIti//gDUTm4IdnoS8A+kjho
 /kkQiS/B6FlvFhnj+SPQwfDesRmsYcSF0wnS21Vx4UlzgaPH0BRyhHIYVxisrFkn543vE2ti/
 qvaypNJq6gvl6G+bvm4JLIxBwfysvaUH0ONQkjR3NZ45sQ6Qu8jP9rftXV0WW0X9unaJXN1AO
 aCv1EJlEhVnUUg28redXAs0b6QL59/avsdPGtNMgwJy7owXNzJwKv64L7fLnE4mYialxAcZ2g
 huFXWnDYB9C3UhHm/y9mXjUy9T4xrLe6IMjgsH4dBfz8ZQT44tG2JHM59ZlbhqQlcdS5MR7XP
 czeIHEeCz9gJgjMDprxHZd/KTcwH/xzJUtzdcbFu7p6/x/rxwZHmk1ueAVox4UO8vQRYAstDq
 0+klq1PBpcGFEUL52hqpmluo+YGlk04rOODejdGXikZIq3gfIVuwg2Y/Et1e6CjFilRA4+Rn8
 xu0+3roTAQ5ESCXMUArccJ3BT0lx3nhq/uAiXauL9b7f/W67r+EwPUqmNgIy4K6oEBlZGzp+P
 rxSkUxHKBo1G/JHzoT97NgfoXQ0fyY1szHGOxWDEkV7+CY3agD+Cy/shS8k0M4xFR/dNgAe9U
 qLglKOcsi1a67Qyd5OFT8bGqW9nZIx3gRsTFWv/NlkKYJUKGivjMp39Rs06j1Rgl1IBDlGHnE
 nsURV/JmVx8Q6uhPgFcVnNiOoP2Z1Z8/cTZFvztn/sdVA1sKkC9xL3q+g09rMZks6IKIgVYJU
 Ic92EjAJQwKdwHFCWLYISjMXhriXh1+zhiEl4K3F8bkd61GaaxBwqrjLTiLsciWSMzlQN/v/3
 hDOjqWJwPoZholWllYuScaQDQbQ6Z6P6o8ZRGZEpYY8pc4B5jFnLda8s68+oiSr0eZ0suF4IN
 qSzwm5b4WlE4S7QtH3QIoss59POjMpZB4ikzZ2VAxmRzXeCckLcGLnGX8b0TH4iw+vo28HwFo
 t9yLRk3gP5pCcBw/9UAVVXdt+gpstGpee23+pYdGJs1OyhXUdfJkXAhLJ4lv2+L9+HMIXwbIH
 /4gwZyD7nG7iU1yr6pb5stw626n0A0dtrZfpxwAwlJ2kIBr9om5tBuX3dxTwJURu8CcQhtn5A
 1laGHQ6z2ZDYCuT3Wjx7J0KBP+MPFQjr7EGL14g9slvSZDXVclrhM/4p6+N6KYqQ20udnOx7w
 Ecyj3y9aT/hvL2C8mZafE5Fn+ZVpteJNAV2C9EiLiT1sNWtcupc2c99kEepckTQlM6b+n/CI6
 e1Ar3RnSTc4kPhs5tQwO/RU8Jf8iga5VUf+aDt+ExHhBFCrE0AIg4DjbSq1miDFi5XmN/z2jD
 FPl3SfTQoQ6hDsz08o9uiS0OhC9Z7mTInW0nMKC5TBpgSKiafsDsKkGFzoSqnrbEpSmougAJB
 HmxbC+ISk2IxaBydlR3oJJN4GIfg9HPp+JXd9X7b5D/+Wqh+i8/CHt/FNKfDiIJV0cSo5lOek
 t6N1xylnlDVBkTYnto30aRkqvb463vCQBfMMio9umBAJj3kckKVbefBh412TYgte1/u4botiH
 /FnMHSHIKItOYe6qv6nMiLjos2IegSVlP4iMQo8yBW9xTZtBdU1G1rOqbQyolsBnNll5DMyfn
 6k4yAzvyqgtlNtLiVNMC+jJ0tqUBxk8lxoI1A9nEMGEZxq4cJrRG2uLgu3KYXHmJ/0BHqODlF
 ntEhWHOBWriTUnb0DpWq17M3RkTHWUUV4eIdgZlXpdoM6K0CjNZozUMzyD4aK+asImZNLSiQb
 zRGAYqkTHQb6qiyneGfY2+oPQHQCi32T0UqdJhnnuChurmir+uy1dInPTGwp0NCZCtXmc/VlF
 X1ek0yqGmx/G1pgPvZtutYp60x+erLQ/UsWFz11zkRNZNaDPGuIzRIKKE+PuM2m1BYQDUX5lt
 mgd2MdWREI1wX0GT6swFTz/jbwXivwFtNZqvzOb+9MX/p5yWSvEoJT9xUggvp4Kvx+9MnfKeG
 fBwTKt+wOb9RQli5gRYcaeDdh+l1YLnhs3KMa7FPNdlVO43n8I97iCmUF6gsF99gYvZj/GUHD
 1ACH9G1IzfguKBu8MOfTCUBI8SnEcfpGObbWXqW5OeMMSW+0Dmaa+Tou+Zd1ix5GBHMQtNC3X
 t0g3oYKU8FY32RVYiVhoHcX7ltBIvFDAcOSjBJXF5mdKasWKvdX4quA6gbA/5zyHZ0iHqaaFO
 UOJ/ocewxqoUyjcXDSs3QvuYwgEhlqke6NaZRtMjaBHbK8Ac0O0s8agUnle1Gsmyxse/DcDif
 rf3XKcH2MND21LnMHYNiSgvEB+BWXx+q1QGmcjyfcJBvBgKEoyV76JMHoOCwzJpC6cYoNWCzy
 wFAEBulosVz8h7AahGdd/oTP/Ph7p461P4LjJTm59OcQ2Shf+MoIz59aN/9ExVRHJil1CzHK2
 LO7Bv6u9S7x42GjpaYzf6utOPOfEq0V7yWN18kyNIo0m/KROF34VpDGwxsQ4vCpIENRGfgqgg
 EK9KT3RvZ031oYbcTnRqdUKlGwMN84tob2dAloeK+dU8XgEvXKBhIEkTGNm/NiauExIN/+tLh
 5DVOlqz0BwR7ktb772WVoK0TWR9oEMRA0L9MyyC4sGNOEVmTPsHmIVOaQQKDmebSPjveIWZLv
 OL9bD1FvRWBVS+yP7bUfKv5kmHIuWy/hXLjrlWe5apRFekq254xfQX8D9JgHUDgHxBOorOtym
 htUuJt0GSbDIqCO0J9JpkmR9K1EFpShEYH9RoyH3PuBn84pTpVtYl6TCWowOKiwst17ZfpKRV
 V/5FiEQ4U+nGgrzvOlkAua/BCvI1nAP5yvTdhAq0XWU6CIN/pcXaEmUSyKiqHh123nanpCn4h
 akLYlyPyUisxspBUhnNM3osJXdSd+TnavcT0iZOZ70oSBvQzj5YyeHXNl7HS1PdSEhBMLTjj2
 kOWnd+Fb7htLG44bxXjnIqVM9+yWFSqJQ8fEOE4QC+kmUdorWNEmBCc0Sgv5cRHwz9Zon6sUC
 ujhI/HKNTFe8Dc3X22A9tlLsTfdNtx359e9OrwK9NKONC6BdUpJaWcfSSpkjtkdXKwrCBKxLC
 Xc2ohTKB/YYDwOqwpZ6ajdZaV7I3EkrXU5qwzFhiVpyKbxTMiF0LaIdYHcQ5bnhzSWfusGOWg
 1WUISwp9ZZtV/rnNm9ovoUBtaMemdehL3ddvwmz2LqiUw0LZ3fNrp5flgrlh3aUmLmBpQKAzu
 HW6RVHtV9E5vfY8gsbBN13YACONKu1TInEb/TNs38tAqj9e5U7kz/7WRLFtJZBW3GyPj+3I8x
 AgnZPHbbDt0znjkrJJ34QZ/haRoS20YJcqi91C1ZGHQVUHB8DF/VS4LA0k9ZgAjAyCq0VX6/x
 siFCJygbyEDglGEFHEXvWmv9BdSBFWjx7Auy3Dsw2WD+7fFJUJSEwZXAtII5w23dDPk5YVCcg
 mAgYC8i8iddU3VhI4NjuKzVPVytUzFzUiIoKapZazjxpQ8VlBOvVn756nyy0nACT3FPurPbq9
 BWXkLxp5lztjz5HLeiDAdXk4i4cd4O48F6BCO8hj1nnmbUTcHg4j4aJ5UjfipR93ItFdFimFC
 JLtpAjyQsuf8LJRmUImKlW/TQ8V+72Wm7CPi410wImd0QxxUhJw9vR+C2evYCe/JOEpIUqEw=
 =
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>

A ksmbd server that is a member of an Active Directory domain cannot
check the NTLM response of a domain user on its own: it has no password
hash for that user. Add a way to defer the check to user space, which
can ask a domain controller over NETLOGON (NetrLogonSamLogonEx).

When the login response for a user carries the new
KSMBD_USER_FLAG_PASSTHROUGH flag, ksmbd no longer computes the NTLMv2
response from a local hash. Instead ksmbd_decode_ntlmssp_auth_blob()
hands the server challenge and the client's user name, domain name,
workstation and NT/LM responses to user space through the new
KSMBD_EVENT_NTLM_AUTHEN_REQUEST event and takes the session base key
from the KSMBD_EVENT_NTLM_AUTHEN_RESPONSE, then continues with the
existing key-exchange path.

The two new events get a strict netlink policy and are validated in
ipc_validate_msg(); ksmbd_nl_init_fixup() keeps strict validation for
commands at or after resv_start_op so the new fixed-size response is
checked.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jan Koester <jan.koester@gmx.net>
=2D--
 fs/smb/server/auth.c          | 68 ++++++++++++++++++++++++++++++++
 fs/smb/server/ksmbd_netlink.h | 41 ++++++++++++++++++++
 fs/smb/server/transport_ipc.c | 73 ++++++++++++++++++++++++++++++++++-
 fs/smb/server/transport_ipc.h |  3 ++
 4 files changed, 183 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index 1b24eb3f39..9a2a3c6a37 100644
=2D-- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -79,6 +79,16 @@ static int calc_ntlmv2_hash(struct ksmbd_conn *conn, st=
ruct ksmbd_session *sess,
 	__le16 *uniname =3D NULL;
 	struct hmac_md5_ctx ctx;
=20
+	/*
+	 * A pass-through user (KSMBD_USER_FLAG_PASSTHROUGH) has no local
+	 * password hash and must never reach the NTLMv2 code -- it is handled
+	 * in ksmbd_decode_ntlmssp_auth_blob() instead. Guard against a NULL
+	 * passkey anyway so a user space that sets KSMBD_USER_FLAG_OK without a
+	 * hash can only fail the login, not crash the kernel.
+	 */
+	if (!user_passkey(sess->user))
+		return -EINVAL;
+
 	hmac_md5_init_usingrawkey(&ctx, user_passkey(sess->user),
 				  CIFS_ENCPWD_SIZE);
=20
@@ -184,6 +194,55 @@ int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct=
 ksmbd_session *sess,
 	return rc;
 }
=20
+/**
+ * ksmbd_auth_ntlm_passthrough() - NTLM authentication by user space
+ * @conn:		connection
+ * @authblob:		authenticate blob
+ * @blob_len:		length of @authblob
+ * @sess_key:		session base key output buffer
+ *
+ * For a user that user space has no password hash for (a domain user): i=
t
+ * checks the response, e.g. with a domain controller, and returns the
+ * session base key.
+ *
+ * Return:	0 on success, error number on error
+ */
+static int ksmbd_auth_ntlm_passthrough(struct ksmbd_conn *conn,
+				       struct authenticate_message *authblob,
+				       int blob_len, char *sess_key)
+{
+	const struct security_buffer *bufs[5] =3D {
+		&authblob->UserName, &authblob->DomainName,
+		&authblob->WorkstationName, &authblob->NtChallengeResponse,
+		&authblob->LmChallengeResponse,
+	};
+	struct ksmbd_ntlm_authen_response *resp;
+	const char *parts[5];
+	unsigned short lens[5];
+	int i, rc;
+
+	for (i =3D 0; i < 5; i++) {
+		unsigned int off =3D le32_to_cpu(bufs[i]->BufferOffset);
+
+		lens[i] =3D le16_to_cpu(bufs[i]->Length);
+		if (blob_len < (u64)off + lens[i])
+			return -EINVAL;
+		parts[i] =3D (const char *)authblob + off;
+	}
+
+	resp =3D ksmbd_ipc_ntlm_authen_request(conn->ntlmssp.cryptkey, parts,
+					     lens);
+	if (!resp)
+		return -EINVAL;
+
+	rc =3D resp->status & KSMBD_USER_FLAG_OK ? 0 : -EINVAL;
+	if (!rc)
+		memcpy(sess_key, resp->session_key, SMB2_NTLMV2_SESSKEY_SIZE);
+	memzero_explicit(resp->session_key, sizeof(resp->session_key));
+	kvfree(resp);
+	return rc;
+}
+
 /**
  * ksmbd_decode_ntlmssp_auth_blob() - helper function to construct
  * authenticate blob
@@ -225,6 +284,14 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticat=
e_message *authblob,
 	    nt_len < CIFS_ENCPWD_SIZE)
 		return -EINVAL;
=20
+	if (test_user_flag(sess->user, KSMBD_USER_FLAG_PASSTHROUGH)) {
+		ret =3D ksmbd_auth_ntlm_passthrough(conn, authblob, blob_len,
+						  sess_key);
+		if (ret)
+			return ret;
+		goto key_exchange;
+	}
+
 	/* TODO : use domain name that imported from configuration file */
 	domain_name =3D smb_strndup_from_utf16((const char *)authblob + dn_off,
 					     dn_len, true, conn->local_nls);
@@ -242,6 +309,7 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate=
_message *authblob,
 	if (ret)
 		return ret;
=20
+key_exchange:
 	/* The recovered secondary session key */
 	if (conn->ntlmssp.client_flags & NTLMSSP_NEGOTIATE_KEY_XCH) {
 		struct arc4_ctx *ctx_arc4;
diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
index 2673522c76..7438e0b0ba 100644
=2D-- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -54,6 +54,11 @@
  *
  *  - KSMBD_EVENT_LOGIN_REQUEST_EXT/RESPONSE_EXT(ksmbd_login_request_ext/=
response_ext)
  *    This event is to get user account extension info to user IPC daemon=
.
+ *
+ *  - KSMBD_EVENT_NTLM_AUTHEN_REQUEST/RESPONSE(ksmbd_ntlm_authen_request/=
response)
+ *    This event is to make NTLM authentication of a user the login respo=
nse
+ *    marked KSMBD_USER_FLAG_PASSTHROUGH to be processed in userspace, e.=
g.
+ *    by a domain controller.
  */
=20
 #define KSMBD_GENL_NAME		"SMBD_GENL"
@@ -161,6 +166,38 @@ struct ksmbd_login_response_ext {
 	__s8	____payload[];
 };
=20
+/*
+ * IPC request to check the NTLM response of a user whose login response
+ * had KSMBD_USER_FLAG_PASSTHROUGH: user space has no password hash for i=
t
+ * and asks someone who has, e.g. a domain controller (NETLOGON).
+ */
+struct ksmbd_ntlm_authen_request {
+	__u32	handle;
+	__u8	challenge[8];		/* the server challenge */
+	__u16	user_name_len;		/* lengths of the payload parts */
+	__u16	domain_name_len;
+	__u16	workstation_len;
+	__u16	nt_response_len;
+	__u16	lm_response_len;
+	__u16	reserved16;
+	__u32	reserved[16];		/* Reserved room */
+	__u8	payload[];		/*
+					 * user name, domain name, workstation
+					 * (UTF-16LE, as the client sent them),
+					 * NT response, LM response
+					 */
+};
+
+/*
+ * IPC response to an NTLM authentication request
+ */
+struct ksmbd_ntlm_authen_response {
+	__u32	handle;
+	__u32	status;			/* KSMBD_USER_FLAG_OK or _BAD_PASSWORD */
+	__u8	session_key[16];	/* the session base key */
+	__u32	reserved[16];		/* Reserved room */
+};
+
 /*
  * IPC request to fetch net share config.
  */
@@ -326,6 +363,9 @@ enum ksmbd_event {
 	KSMBD_EVENT_LOGIN_REQUEST_EXT,
 	KSMBD_EVENT_LOGIN_RESPONSE_EXT,
=20
+	KSMBD_EVENT_NTLM_AUTHEN_REQUEST,
+	KSMBD_EVENT_NTLM_AUTHEN_RESPONSE,
+
 	__KSMBD_EVENT_MAX,
 	KSMBD_EVENT_MAX =3D __KSMBD_EVENT_MAX - 1
 };
@@ -357,6 +397,7 @@ enum KSMBD_TREE_CONN_STATUS {
 #define KSMBD_USER_FLAG_GUEST_ACCOUNT	BIT(4)
 #define KSMBD_USER_FLAG_DELAY_SESSION	BIT(5)
 #define KSMBD_USER_FLAG_EXTENSION	BIT(6)
+#define KSMBD_USER_FLAG_PASSTHROUGH	BIT(7)
=20
 /*
  * Share config flags.
diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index e550aa41ad..578a22dbff 100644
=2D-- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -127,6 +127,10 @@ static const struct nla_policy ksmbd_nl_policy[KSMBD_=
EVENT_MAX + 1] =3D {
 	[KSMBD_EVENT_LOGIN_RESPONSE_EXT] =3D {
 		.len =3D sizeof(struct ksmbd_login_response_ext),
 	},
+	[KSMBD_EVENT_NTLM_AUTHEN_REQUEST] =3D
+		NLA_POLICY_MIN_LEN(sizeof(struct ksmbd_ntlm_authen_request)),
+	[KSMBD_EVENT_NTLM_AUTHEN_RESPONSE] =3D
+		NLA_POLICY_EXACT_LEN(sizeof(struct ksmbd_ntlm_authen_response)),
 };
=20
 static struct genl_ops ksmbd_genl_ops[] =3D {
@@ -202,6 +206,14 @@ static struct genl_ops ksmbd_genl_ops[] =3D {
 		.cmd	=3D KSMBD_EVENT_LOGIN_RESPONSE_EXT,
 		.doit	=3D handle_generic_event,
 	},
+	{
+		.cmd	=3D KSMBD_EVENT_NTLM_AUTHEN_REQUEST,
+		.doit	=3D handle_unsupported_event,
+	},
+	{
+		.cmd	=3D KSMBD_EVENT_NTLM_AUTHEN_RESPONSE,
+		.doit	=3D handle_generic_event,
+	},
 };
=20
 static struct genl_family ksmbd_genl_family =3D {
@@ -220,9 +232,11 @@ static void ksmbd_nl_init_fixup(void)
 {
 	int i;
=20
+	/* the commands from resv_start_op on are validated strictly */
 	for (i =3D 0; i < ARRAY_SIZE(ksmbd_genl_ops); i++)
-		ksmbd_genl_ops[i].validate =3D GENL_DONT_VALIDATE_STRICT |
-						GENL_DONT_VALIDATE_DUMP;
+		if (ksmbd_genl_ops[i].cmd < ksmbd_genl_family.resv_start_op)
+			ksmbd_genl_ops[i].validate =3D GENL_DONT_VALIDATE_STRICT |
+							GENL_DONT_VALIDATE_DUMP;
=20
 	ksmbd_genl_family.policy =3D ksmbd_nl_policy;
 }
@@ -549,6 +563,10 @@ static int ipc_validate_msg(struct ipc_msg_table_entr=
y *entry)
 			return -EINVAL;
 		break;
 	}
+	case KSMBD_EVENT_NTLM_AUTHEN_REQUEST:
+		if (entry->msg_sz !=3D sizeof(struct ksmbd_ntlm_authen_response))
+			return -EINVAL;
+		break;
 	case KSMBD_EVENT_LOGIN_REQUEST_EXT:
 	{
 		struct ksmbd_login_response_ext *resp =3D entry->response;
@@ -702,6 +720,57 @@ ksmbd_ipc_spnego_authen_request(const char *spnego_bl=
ob, int blob_len)
 	return resp;
 }
=20
+/**
+ * ksmbd_ipc_ntlm_authen_request() - have user space check an NTLM respon=
se
+ * @challenge:		the server challenge (CIFS_CRYPTO_KEY_SIZE bytes)
+ * @parts:		user name, domain name, workstation (UTF-16LE),
+ *			NT response, LM response
+ * @lens:		their lengths
+ *
+ * For a user whose login response had KSMBD_USER_FLAG_PASSTHROUGH.
+ *
+ * Return:	the response (kvfree() it), NULL on error
+ */
+struct ksmbd_ntlm_authen_response *
+ksmbd_ipc_ntlm_authen_request(const char *challenge, const char *parts[5]=
,
+			      const unsigned short lens[5])
+{
+	struct ksmbd_ipc_msg *msg;
+	struct ksmbd_ntlm_authen_request *req;
+	struct ksmbd_ntlm_authen_response *resp;
+	size_t payload_sz =3D 0, off =3D 0;
+	int i;
+
+	for (i =3D 0; i < 5; i++)
+		payload_sz +=3D lens[i];
+	if (payload_sz > KSMBD_IPC_MAX_PAYLOAD)
+		return NULL;
+
+	msg =3D ipc_msg_alloc(sizeof(struct ksmbd_ntlm_authen_request) +
+			    payload_sz);
+	if (!msg)
+		return NULL;
+
+	msg->type =3D KSMBD_EVENT_NTLM_AUTHEN_REQUEST;
+	req =3D (struct ksmbd_ntlm_authen_request *)msg->payload;
+	req->handle =3D ksmbd_acquire_id(&ipc_ida);
+	memcpy(req->challenge, challenge, sizeof(req->challenge));
+	req->user_name_len =3D lens[0];
+	req->domain_name_len =3D lens[1];
+	req->workstation_len =3D lens[2];
+	req->nt_response_len =3D lens[3];
+	req->lm_response_len =3D lens[4];
+	for (i =3D 0; i < 5; i++) {
+		memcpy(req->payload + off, parts[i], lens[i]);
+		off +=3D lens[i];
+	}
+
+	resp =3D ipc_msg_send_request(msg, req->handle);
+	ipc_msg_handle_free(req->handle);
+	ipc_msg_free(msg);
+	return resp;
+}
+
 struct ksmbd_tree_connect_response *
 ksmbd_ipc_tree_connect_request(struct ksmbd_session *sess,
 			       struct ksmbd_share_config *share,
diff --git a/fs/smb/server/transport_ipc.h b/fs/smb/server/transport_ipc.h
index e51850f142..f957a33ae3 100644
=2D-- a/fs/smb/server/transport_ipc.h
+++ b/fs/smb/server/transport_ipc.h
@@ -32,6 +32,9 @@ struct ksmbd_share_config_response *
 ksmbd_ipc_share_config_request(const char *name);
 struct ksmbd_spnego_authen_response *
 ksmbd_ipc_spnego_authen_request(const char *spnego_blob, int blob_len);
+struct ksmbd_ntlm_authen_response *
+ksmbd_ipc_ntlm_authen_request(const char *challenge, const char *parts[5]=
,
+			      const unsigned short lens[5]);
 int ksmbd_ipc_id_alloc(void);
 void ksmbd_rpc_id_free(int handle);
 struct ksmbd_rpc_command *ksmbd_rpc_open(struct ksmbd_session *sess, int =
handle);
=2D-=20
2.56.0

