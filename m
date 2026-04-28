Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAA146AF01
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 16:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777392762; cv=pass; b=enpXj0bKGROjotqVkEzDS/RyW9JnA9rEWdIpRHhr1ufIeDvz+S47c2bXrvFZSl4AucWiWZehvyVZJyuZzyXiDmEEJyFuXxfrTFbTD8pll94531yi1jZ0HTQoTv9tSxxbd3P79c5RJKaXBMh9oxww32+KfoEBWDaNlFPVY1rdgB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777392762; c=relaxed/simple;
	bh=q6JgxFyLvJCahXylzyug/1dX1ICrpJy19p5dtVuDOXg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QODIIVbWzZmts9JvA7j8Zgy5iZruBiFuCm2/i9ta23oaH8D67OfnhCEPKCpDUfRwz0f5cc3C6sQ2OXKCqTI+Z7c/TkkCTclZlm3tyDHXWWFRbHmshKxoooUgFXrxhfR1jrY/sSp3q0NmuG/Vh0GVJd0OVa2b1TaDd99nn7bni6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YtwWsaTf; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YtwWsaTf"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b941762394aso1596627766b.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 09:12:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777392759; cv=none;
        d=google.com; s=arc-20240605;
        b=cQFckQ66kU1PRWyKFeQgKj9QtqjtLhzPR1uD1FrxOnsaHgjx4iPSNMsJbW8H8nPzJu
         qsPAb7OP2RhD3IVVcStwnCIfhdqnirVVd1WAYGTnpfi7FQ6930M+OTWJSzfJFNvG9YR5
         oLCFNo1ytzQHbPhZ7uMHbzjM/tN/yquPqkSQwFVqKeoKhn/0tZQ8aie5fqjSnvt5NslG
         8+yQO3Vjb10UHEHfvoa1ljv/W4OTxPOuhYpvEnA54tL3KOOf+/Z1xinzz63RFZ6QDzzC
         0VUzKaDAjbUvtNu8pCS8D2bh4eOrbauYuA922OpXNbSq7540hxExL53KIuf5xBLOYCbg
         rXlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G8PidlKSHO0r02Iwhfxhmz5vcZ6K78QPaLAA3PHEonk=;
        fh=pBtc+Us4Lqm9k2lR+3InzWekFX9j6CH3UW1ikKMXm/Q=;
        b=fjDsx9TdKHts/4rXGbyPpjy8+jjRHFhZHlqSAGSUUs/UsFLOitVQIJQ4g3mI7imo0O
         fRs6VNDhahb0y93k7aydwIzWTYPjnDbjK0tnIAIh9Zt+oMO90jVpkZO62POvvhYMswl9
         Xg3mfDBHhD4scUa0ajfyCOrV61q5MuRvtfny7uYC8FhWefSv80+EWama4bIXu6fltO6m
         oysmnNnhfC9mOiqhtanW2pUxdeBY3sIspM79V5ll7mslMo0z89r+vGt3n201pHlCyErj
         klGZf9cFIRzTrZGARHMwsMtxg9GexGOCXllHrwX4MqMfaM/1HX7SHmb8Xjqz619f/W+J
         8NUw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777392759; x=1777997559; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G8PidlKSHO0r02Iwhfxhmz5vcZ6K78QPaLAA3PHEonk=;
        b=YtwWsaTfWEjXVyUzSlvUjUwlTQmsDIAnRThkbQwtw1zXJugfWD0mwtZgARufTDAhVy
         CxpmscJ2Z04rfuiTYI4nGuQLgvxh0+Dt4NKpU/ne6SVn3hQX3WXG4pqcYo/D180LU4A5
         oYEpUTco9bvaxGOvueOHyMP/EHmdbjy0ZTjs6EQWk7cMSU49oIDXdSCtOPhlBFoLFc+8
         8IF2ffdrAm1aviqCvS7YEm3gn79pbKq6HeAQcqVAwN14o16onpdOKkyTEL8kzhSBC53p
         4c19jnqyM8FTuOGmW10WYPFmXOSMCg0vwka1RTLF0kQXI6P7kYHuPD2GkNtFq3B+aCPi
         lVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777392759; x=1777997559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G8PidlKSHO0r02Iwhfxhmz5vcZ6K78QPaLAA3PHEonk=;
        b=P+jTvC0YDqiqDsA2ybjHJ6Uy1/SI7LJ8/8XIiidA5FpkKox7XSnX3259F6JwxtMyZJ
         xTUj610Ag/7uv8f5Bo/ZZIAHUR/XX8Oha6bJAVsEmJGe9A/K3XgLgyB/HFOCjdFQwYZm
         6XTK7UoMXmNsBS56ITK8QnmIEkRCYAAvQlFJh8P5LZc3l1uqAsSEQpwILs7VO/rBIfg3
         07Z7l8LLga7EVp+WxtbN2zzHSl6xNwGoKp7ACkCEVZj3oRfL7Q2157i5mIcVjUMkf8J0
         7nSmPotLB1wpRXcQu9QnMTTLVLyqXZMZKspru7bg90hHV326qr68mo2kNjD/D0rK+yI7
         +QnA==
X-Forwarded-Encrypted: i=1; AFNElJ9hrbYrlAtUdD2smAOGJ/b1qyh11Wyde0kJHM5eBPsig4hOY6ma0D/275Hww9esaieXorcrUAqHabrk@vger.kernel.org
X-Gm-Message-State: AOJu0YyuhhPoShNmgsERncyAkUNIhZm3HpOS13bXrUaRyfAJ9T9mdKef
	i1pcgxSZUsdc3ysHDfm+UQt0OUlp/KQ6jt7dYnHz0DMmiRSHvh7ablos+3Tq3Uha8Vp91hHSATZ
	l1PGnvEvzseuIGvQLvDRcz8xPwS2A/L4Ey8pl
X-Gm-Gg: AeBDieveJRq5z3/+qUex9NOZJqlO3ed3GH1m+A2TcasP78cf+ulaZFb7NwfgpN04zno
	81Fl3IHVQKqK+klsvcpf3/fXfF/sUaLbAlE8NSAedsk80h+Y9xf3XfdhA0uq5hj19iqNIgs1zgI
	LNLSE04cfyxk8t3hL9DDxZvt1LHW8joEJ/q8tmKuX9XXHTeAcW2M3gtXmftHq8P5vZI4ZrB62+T
	BzcqjEUCQw2c6Oo5vf/3/tcKQZx5R2qT7w8zxGp7u42j1u1COvOqZSfeoGOQ0UGTJRQdGp8oqf0
	DXioH+fmG8bBu5oB
X-Received: by 2002:a17:907:8714:b0:bae:8734:18b4 with SMTP id
 a640c23a62f3a-bb8023bc02dmr171881566b.16.1777392758324; Tue, 28 Apr 2026
 09:12:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=oV8kcE6hXPoUVQAYGaiz+2OERoSRLAS6X+q9KJ_8w8YQ@mail.gmail.com>
 <438478a7-c965-4a2a-9c4a-84b5f77d6dbe@samba.org> <CANT5p=ortwT7ensa+kKoCa=wMnGETpqaQuBnhDWMSNu82KsqFg@mail.gmail.com>
 <e248f3de-bbaf-48e3-9e86-0beb9a789556@talpey.com>
In-Reply-To: <e248f3de-bbaf-48e3-9e86-0beb9a789556@talpey.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 28 Apr 2026 21:42:27 +0530
X-Gm-Features: AVHnY4K2XjlTsTSCHJLslIA3lI_-DAhznUe5mx_MQp1-M-AJVwKvcSVDlI1FDuI
Message-ID: <CANT5p=rt9V8Guiyt_H_Y8g_NEu2ZgHgbYLGM1CBcgoAZbzjXsg@mail.gmail.com>
Subject: Re: "Intent" of VFS lookups
To: Tom Talpey <tom@talpey.com>
Cc: Ralph Boehme <slow@samba.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 24, 2026 at 7:11=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 4/24/2026 9:20 AM, Shyam Prasad N wrote:
> > On Thu, Apr 23, 2026 at 11:13=E2=80=AFPM Ralph Boehme <slow@samba.org> =
wrote:
> >>
> >> On 4/23/26 7:01 PM, Shyam Prasad N wrote:
> >>> Wanted to understand if this is a problem for other filesystems or if
> >>> it is specific to SMB protocol?
> >>> SMB2+ protocol mandate that open call specifies if the file being
> >>> opened is a directory or not (regular file).
> >> sure? From memory (though the logic has always kind of escaped me) if
> >> you neither specify FILE_DIRECTORY_FILE nor FILE_NON_DIRECTORY_FILE th=
e
> >> server is supposed to open the object regardless of the type.
> >
> > Hi Ralph,
> >
> > That's interesting. The spec does not seem to define this. Perhaps purp=
osely?
> > Will try and prototype a change to verify.
>
> This would be filesystem behavior and therefore it would be in MS-FSA,
> not in the SMB2/3 protocol.
>
> MS-FSA does indeed specify that in certain conditions, an open must
> succeed on a directory even if both DIRECTORY_FILE and NON_DIRECTORY_FILE
> are false (page 60 section 2.1.5.1):
>
>   If CreateOptions.FILE_DIRECTORY_FILE is TRUE then StreamTypeToOpen =3D
> DirectoryStream.
> =EF=82=A7 Else if StreamTypeNameToOpen is "$INDEX_ALLOCATION" then
> StreamTypeToOpen =3D
> DirectoryStream.
> =EF=82=A7 Else if CreateOptions.FILE_NON_DIRECTORY_FILE is FALSE,
> StreamNameToOpen is
> empty, StreamTypeNameToOpen is empty, Open.File is not NULL, and
> Open.File.FileType is
> DirectoryFile then StreamTypeToOpen =3D DirectoryStream.
> =EF=82=A7 Else StreamTypeToOpen =3D DataStream
>
> There are a bunch of other cases involving trailing separators, etc.
>
> MS-FSA is, of course, not the only filesystem type which can be
> exported by SMB.
>
> Tom.

Thanks Tom. Will try some experiments with this.

--=20
Regards,
Shyam
