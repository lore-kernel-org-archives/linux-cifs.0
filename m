Received: from mail-oi1-f194.google.com (mail-oi1-f194.google.com [209.85.167.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146F920B03
	for <linux-cifs@vger.kernel.org>; Thu,  4 Jan 2024 10:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iM9u6OqQ"
Received: by mail-oi1-f194.google.com with SMTP id 5614622812f47-3bbf67d619cso210351b6e.2
        for <linux-cifs@vger.kernel.org>; Thu, 04 Jan 2024 02:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704363041; x=1704967841; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jabjOYcxDldzVYCA3YnUF4Dvx9TK1s/lsbRCk8g+mrE=;
        b=iM9u6OqQNOHvMxnSRzc7HY/eDjZ4ikROSiD+kU/dfvO3sJKgxNbCacRPWg56g5wocw
         fxLQtBKct8BtP5B0XHp7ouQ/fpVqnArsjjtocIeAhfHi21+ljoydlVUkqPxLtQhJ7YIP
         qzka94lCgh4KSYEO/wvzLDVSQDECOSovJWA2NuBwExtiGZiPDrvyI12Q7b/5TV9QvF02
         /tIRsbQg4c2Cp2/rkyyg4yf4nsXdWbDyLmhTXJugG36+OLRI/45HxpPlkFyjaXWiu09/
         xOTiLLuTXIEry1sBJq5NRvN1F6J4/UMvXHrhkrVR4TlXsmMvQFTwZZjc4LsOP/ZgVQRf
         BcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704363041; x=1704967841;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jabjOYcxDldzVYCA3YnUF4Dvx9TK1s/lsbRCk8g+mrE=;
        b=lQ40plIf3w8DEPoOBQXsRg6x/yyA+Ty3jI+opkE3WTQn/Nx7HNZFhSP96KdStpbycQ
         UZJ98nzWlXYH1ECkJVpdQ4u5nLAEyK+vozgeuSUuK2n0K/wCvY84483D/jVrkXnh06Gh
         YAvFA9JEAUa72JzTXffq0D9MQTbxxG/JPQeQ4RE1ClUc6PnHerNtKoHafZp/MDQ1yrXz
         xJJ4htLvvFlvzrRQkwdxZyW3l0o7zMg0NaJWp7JHE9J4NbaRXy8wmR0qlPoDWdIrM1Mk
         I60VLXwj4Qd6otuefskn76/yOxNW6JDwED/FQpo3QSB5sqqQ/w2smJhDxzlDpndFtLci
         PowQ==
X-Gm-Message-State: AOJu0YzQOafESVwfQksukRS81UQRriv89xbaksvgZdDVr9ltiZxai+Lw
	EZqABZuPOt726p0fdiVEwJ1zf0cN6rWf26pi28vnnhZZVKZQSLzgmg==
X-Google-Smtp-Source: AGHT+IHy1XifmMX6xK2JHPVL4zeSPQDo/s2+GO2xbkAD0ijOy2rU3upMMUb+LNmVI34PZSQOw8GM0EQ3Qxm9gGBI/m4=
X-Received: by 2002:aca:1710:0:b0:3bc:21ec:fd4b with SMTP id
 j16-20020aca1710000000b003bc21ecfd4bmr298101oii.65.1704363040873; Thu, 04 Jan
 2024 02:10:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anna Naden <nadenanna1234@gmail.com>
Date: Thu, 4 Jan 2024 04:10:29 -0600
Message-ID: <CAH_HBJBx7VuPobZvSGW-zWO_YiacKKsNq8pCPZrA_GN2t1qXDg@mail.gmail.com>
Subject: CIFS with Virtual box won't mount share
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

 H e r e   i s   m y   i s s u e :

kernel 6.2.0-39

mount.cifs version 6.14

 S e r v e r :   W i n d o w s   1 1   P r o

 C l i e n t :   u b u n t u   2 2 ,   r u n n i n g   i n   a   v i r
t u a l   b o x   o n   t h e   W i n d o w s   1 1   P r o   s e r v
e r

 M o u n t   c o m m a n d :   s u d o   m o u n t   - r     v e r b o
s e   - t   c i f s   - o   v e r s = 3 , u i d = * * * , g i d = 1 0
0 0 ,   c r e d e n t i a l s = c r e d s . t x t   / / < I P > / S H
A R E N A M E     / m n t / w i n s h a r e

 E r r o r   m e s s a g e :     m o u n t   e r r o r ( 1 3 )   P e r
m i s s i o n   d e n i e d

 D m e s g   s i m p l y   s a y s
 A t t e m p t i n g   t o   m o u n t &
 S t a t u s   c o d e   r e t u r n e d   0 x c 0 0 0 0 0 6 d   S T A
T U S _ L O G I N _ F A I L U R E
 s E N D   E R R O R   I N   s E S S s E T U P   =   - 1 3

 C h a n g i n g   t h e   v e r s i o n   t o   1   o r   2   r e s u
l t s   i n     i n v a l i d   a r g u m e n t .

 T h i s   i s   a   f r e s h   i n s t a l l   o n   b o t h   m a c
h i n e s .

 T h e   s e r v e r   s u c c e s s f u l l y   e x p o s e s   t h e
  s h a r e   t o   a n o t h e r   W i n d o w s   m a c h i n e   o
n   m   L A N
 T h e   c l i e n t   c a n   p i n g   t h e   s e r v e r

 I   d o n   t   k n o w   h o w   t o   c h e c k   m y   C I F S   v
e r s i o n   b u t   i t   i s   t h e   l a t e s t

 A n y   h e l p   w o u l d   b e   a p p r e c i a t e d

 S e n t   f r o m   M a i l   f o r   W i n d o w s
