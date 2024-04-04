Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9918F1AAC4
	for <linux-cifs@vger.kernel.org>; Thu,  4 Apr 2024 02:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712196660; cv=none; b=OC931fVzfnDnFkh/Jg59s64jlSRX3epBx1CZjrRqqHYX6fjNUopaNTXcjPeuhOWrZh9+H2vEfjmbltHhQefgFxDqWGgoeeNqaOE7/GVewKzG/o8df45QS2fEaO6TqWr/PnxiP0AwNXJN2F0XhLVewBhpglHYm3Jx+IvLiQvVOq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712196660; c=relaxed/simple;
	bh=RyG1k5fU+WlmBVHGHbs7OaZU0cd3g8tfRe0++06gHtM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X1dJKmMtBwnnQcMcKfNoBwwyxD3/wCdVoJjMZhT98YR6OVYL+9qikxs5OCL82EMh5kAw4oYifKzfLjkh25utx5Rxw79ToWO1+/nh09If6KGA7FhVRG1dNEb05TBGQJBdZGaZIJOc3siMuel7Qf1S49W27ZW9uG9hApSP0xr3+2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pi/VJ6OW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pi/VJ6OW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712196656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EtgZp2v1ZlTC+w/v6NmBVWhjgdZ5xgfHtzXIQ8mqmeM=;
	b=Pi/VJ6OWE2ihp+ovh/SZ81hD8qLmwuNUyFnpkuSNoSJJDCAkjymnh4OK9SslGj+rc4vCrt
	ts3vDkQo2IqMAnJhKbEDEVdMOI3STg+Ov8W5RCczA2OqXwcweet68zP5kmnEz3fpohKVht
	F6R/uScih1HZS/YQQNfzzgqPS7hYfpw=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-19m-ts-bNym8YNC8Lv5e6Q-1; Wed, 03 Apr 2024 22:10:54 -0400
X-MC-Unique: 19m-ts-bNym8YNC8Lv5e6Q-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-dd933a044baso2037934276.0
        for <linux-cifs@vger.kernel.org>; Wed, 03 Apr 2024 19:10:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712196653; x=1712801453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EtgZp2v1ZlTC+w/v6NmBVWhjgdZ5xgfHtzXIQ8mqmeM=;
        b=eXDWPEqfHwr01GtSFNVxfNTpYGo839zyQowTNZKHJjV4unyv/kAKb0dEYsKi6R6wa7
         BpH7XTqSpJgRA8LSNKbFZDBMfM9Xvx5/dlubjZ+uui/CCY2Py0eNTUvyNFtdadKoqBCM
         76l/UoIWo4+5U4oIqi0C0bPCiASMgc/Gv41DXicGCMVd+81oI4ORI0scZLNe1P7UcFuN
         HxlmnJTkVXQnr2PcXanGmVlOQFjRTgWhAY4sVTPyd/zZeBJeL+8W1bDAEjVQmdem6p2N
         r8eLbFjqAgmi0RtCjoFM9/IG0l9IXCCf+4IzqfBWp8pVE/vVuzaDxScF0qGdNUdijpiT
         SF9A==
X-Gm-Message-State: AOJu0YzRQbAfnIDV5+OIB4eSpIU4E/eNsTjvhDXTaF19fGIfEVzb04dB
	TfVHfMYlSFDt8qWqTnwymb9gkmfNWcDfcNCwJANWS8QbXOUAvRoLFC+rktld7GPASnRyVxZnNpF
	1pEIIninlT72hHFqBR2LPp9hnCtTpiaj9vmP4WM0A4IzQ6HJaY9KTnj7iVBoYp4udiRoZm3tghk
	uKPrIOdB8POZffodLxUXLUtXOJHKXg+Y98W2YXmc8xDg==
X-Received: by 2002:a25:add2:0:b0:dc2:271a:3799 with SMTP id d18-20020a25add2000000b00dc2271a3799mr3377561ybe.23.1712196653307;
        Wed, 03 Apr 2024 19:10:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0xKJvSTK/HVJfxwoChg7NqaCxnRJovXE/+FmC5gLz6PnFMn0lu+xXDXdr787VlAujAuKhUJgBK5mzea+8qXU=
X-Received: by 2002:a25:add2:0:b0:dc2:271a:3799 with SMTP id
 d18-20020a25add2000000b00dc2271a3799mr3377552ybe.23.1712196652827; Wed, 03
 Apr 2024 19:10:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403052448.4290-1-david.voit@gmail.com> <20240403052448.4290-2-david.voit@gmail.com>
In-Reply-To: <20240403052448.4290-2-david.voit@gmail.com>
From: Jacob Shivers <jshivers@redhat.com>
Date: Wed, 3 Apr 2024 22:10:16 -0400
Message-ID: <CALe0_773CAb5DzFdqVOiQH4Nz7hpDSP=AWzicYJsuAt=SD-d5w@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] Implement CLDAP Ping to find the closest site
To: David Voit <david.voit@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested and can confirm that all queries go to site local DC when said
DC is properly configured, e.g. NetLogon running.

Great feature!

On Wed, Apr 3, 2024 at 1:25=E2=80=AFAM David Voit <david.voit@gmail.com> wr=
ote:
>
> For domain based DFS we always need to contact the domain controllers.
> On setups, which are using bigger AD installations you could get random d=
c on the other side of the world,
> if you don't have site support. This can lead to network timeouts and oth=
er problems.
>
> CLDAP-Ping uses ASN.1 + UDP (CLDAP) and custom-DCE encoding including DNa=
me compressions without
> field separation. Finally after finding the sitename we now need to do a =
DNS SRV lookups to find
> the correct IPs to our closest site and fill up the remaining IPs from th=
e global list.
>
> Signed-off-by: David Voit <david.voit@gmail.com>
> ---
>  Makefile.am    |  15 ++-
>  cldap_ping.c   | 346 +++++++++++++++++++++++++++++++++++++++++++++++++
>  cldap_ping.h   |  14 ++
>  mount.cifs.c   |   5 +-
>  resolve_host.c | 258 +++++++++++++++++++++++++++++++-----
>  resolve_host.h |   6 +-
>  6 files changed, 606 insertions(+), 38 deletions(-)
>  create mode 100644 cldap_ping.c
>  create mode 100644 cldap_ping.h
>
> diff --git a/Makefile.am b/Makefile.am
> index 1a22266..7877823 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -3,8 +3,8 @@ ACLOCAL_AMFLAGS =3D -I aclocal
>
>  root_exec_sbindir =3D $(ROOTSBINDIR)
>  root_exec_sbin_PROGRAMS =3D mount.cifs
> -mount_cifs_SOURCES =3D mount.cifs.c mtab.c resolve_host.c util.c
> -mount_cifs_LDADD =3D $(LIBCAP) $(CAPNG_LDADD) $(RT_LDADD)
> +mount_cifs_SOURCES =3D mount.cifs.c mtab.c $(resolve_hosts_SOURCES) util=
.c
> +mount_cifs_LDADD =3D $(LIBCAP) $(CAPNG_LDADD) $(RT_LDADD) $(resolve_host=
s_LDADD)
>  include_HEADERS =3D cifsidmap.h
>  rst_man_pages =3D mount.cifs.8
>
> @@ -28,6 +28,9 @@ bin_PROGRAMS =3D
>  bin_SCRIPTS =3D
>  sbin_PROGRAMS =3D
>
> +resolve_hosts_SOURCES =3D data_blob.c asn1.c cldap_ping.c resolve_host.c
> +resolve_hosts_LDADD =3D -ltalloc -lresolv
> +
>  if CONFIG_CIFSUPCALL
>  sbin_PROGRAMS +=3D cifs.upcall
>  cifs_upcall_SOURCES =3D cifs.upcall.c data_blob.c asn1.c spnego.c
> @@ -43,8 +46,8 @@ endif
>
>  if CONFIG_CIFSCREDS
>  bin_PROGRAMS +=3D cifscreds
> -cifscreds_SOURCES =3D cifscreds.c cifskey.c resolve_host.c util.c
> -cifscreds_LDADD =3D -lkeyutils
> +cifscreds_SOURCES =3D cifscreds.c cifskey.c $(resolve_hosts_SOURCES) uti=
l.c
> +cifscreds_LDADD =3D -lkeyutils $(resolve_hosts_LDADD)
>
>  rst_man_pages +=3D cifscreds.1
>
> @@ -105,8 +108,8 @@ endif
>  if CONFIG_PAM
>  pam_PROGRAMS =3D pam_cifscreds.so
>  rst_man_pages +=3D pam_cifscreds.8
> -pam_cifscreds.so: pam_cifscreds.c cifskey.c resolve_host.c util.c
> -       $(CC) $(DEFS) $(CFLAGS) $(AM_CFLAGS) $(LDFLAGS) -shared -fpic -o =
$@ $+ -lpam -lkeyutils
> +pam_cifscreds.so: pam_cifscreds.c cifskey.c $(resolve_hosts_SOURCES) uti=
l.c
> +       $(CC) $(DEFS) $(CFLAGS) $(AM_CFLAGS) $(LDFLAGS) -shared -fpic -o =
$@ $+ -lpam -lkeyutils $(resolve_hosts_LDADD)
>
>  endif
>
> diff --git a/cldap_ping.c b/cldap_ping.c
> new file mode 100644
> index 0000000..725ba2c
> --- /dev/null
> +++ b/cldap_ping.c
> @@ -0,0 +1,346 @@
> +/*
> + * CLDAP Ping to find closest ClientSiteName
> + *
> + * Copyright (C) 2024 David Voit (david.voit@gmail.com)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 3 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <talloc.h>
> +#include <string.h>
> +#include <sys/socket.h>
> +#include <arpa/inet.h>
> +#include <unistd.h>
> +#include <resolv.h>
> +#include <stdbool.h>
> +#include "data_blob.h"
> +#include "asn1.h"
> +#include "cldap_ping.h"
> +
> +#define LDAP_DNS_DOMAIN "DnsDomain"
> +#define LDAP_DNS_DOMAIN_LEN strlen(LDAP_DNS_DOMAIN)
> +#define LDAP_NT_VERSION "NtVer"
> +#define LDAP_NT_VERSION_LEN strlen(LDAP_NT_VERSION)
> +#define LDAP_ATTRIBUTE_NETLOGON "NetLogon"
> +#define LDAP_ATTRIBUTE_NETLOGON_LEN strlen(LDAP_ATTRIBUTE_NETLOGON)
> +
> +
> +// Parse a ASN.1 BER tag size-field, returns start of payload of tag
> +char *parse_ber_size(char *buf, size_t *tag_size) {
> +       size_t size =3D *buf & 0xff;
> +       char *ret =3D (buf + 1);
> +       if (size >=3D 0x81) {
> +               switch (size) {
> +                       case 0x81:
> +                               size =3D *ret & 0xff;
> +                               ret +=3D 1;
> +                               break;
> +                       case 0x82:
> +                               size =3D (*ret << 8) | (*(ret + 1) & 0xff=
);
> +                               ret +=3D 2;
> +                               break;
> +                       case 0x83:
> +                               size =3D (*ret << 16) | (*(ret + 1) << 8)=
 | (*(ret + 2) & 0xff);
> +                               ret +=3D 3;
> +                               break;
> +                       case 0x84:
> +                               size =3D (*ret << 24) | (*(ret + 1) << 16=
) | (*(ret + 2) << 8) | (*(ret + 3) & 0xff);
> +                               ret +=3D 4;
> +                               break;
> +                       default:
> +                               return NULL;
> +               }
> +       }
> +
> +       *tag_size =3D size;
> +       return ret;
> +}
> +
> +// simple wrapper over dn_expand which also calculates the new offset fo=
r the next compressed dn
> +int read_dns_string(char *buf, size_t buf_size, char *dest, size_t dest_=
size, size_t *offset) {
> +       int compressed_length =3D dn_expand((u_char *)buf, (u_char *)buf+=
buf_size, (u_char *)buf + *offset, dest, (int)dest_size);
> +       if (compressed_length < 0) {
> +               return -1;
> +       }
> +
> +       *offset =3D *offset+compressed_length;
> +
> +       return 0;
> +}
> +
> +// LDAP request for: (&(DnsDomain=3DDOMAIN_HERE)(NtVer=3D\\06\\00\\00\\0=
0))
> +ASN1_DATA *generate_cldap_query(char *domain) {
> +       ASN1_DATA *data;
> +       TALLOC_CTX *mem_ctx =3D talloc_init("cldap");
> +
> +       data =3D asn1_init(mem_ctx);
> +       asn1_push_tag(data, ASN1_SEQUENCE(0));
> +
> +       // Message id
> +       asn1_push_tag(data, ASN1_INTEGER);
> +       asn1_write_uint8(data, 1);
> +       asn1_pop_tag(data);
> +
> +       // SearchRequest
> +       asn1_push_tag(data, ASN1_APPLICATION(3));
> +
> +       // empty baseObject
> +       asn1_push_tag(data, ASN1_OCTET_STRING);
> +       asn1_pop_tag(data);
> +
> +       // scope 0 =3D baseObject
> +       asn1_push_tag(data, ASN1_ENUMERATED);
> +       asn1_write_uint8(data, 0);
> +       asn1_pop_tag(data);
> +
> +       // derefAliasses 0=3DneverDerefAlias
> +       asn1_push_tag(data, ASN1_ENUMERATED);
> +       asn1_write_uint8(data, 0);
> +       asn1_pop_tag(data);
> +
> +       // sizeLimit
> +       asn1_push_tag(data, ASN1_INTEGER);
> +       asn1_write_uint8(data, 0);
> +       asn1_pop_tag(data);
> +
> +       // timeLimit
> +       asn1_push_tag(data, ASN1_INTEGER);
> +       asn1_write_uint8(data, 0);
> +       asn1_pop_tag(data);
> +
> +       // typesOnly
> +       asn1_push_tag(data, ASN1_BOOLEAN);
> +       asn1_write_uint8(data, 0);
> +       asn1_pop_tag(data);
> +
> +       // AND
> +       asn1_push_tag(data, ASN1_CONTEXT(0));
> +       // equalityMatch
> +       asn1_push_tag(data, ASN1_CONTEXT(3));
> +       asn1_write_OctetString(data, LDAP_DNS_DOMAIN, LDAP_DNS_DOMAIN_LEN=
);
> +       asn1_write_OctetString(data, domain, strlen(domain));
> +       asn1_pop_tag(data);
> +
> +       // equalityMatch
> +       asn1_push_tag(data, ASN1_CONTEXT(3));
> +       asn1_write_OctetString(data, LDAP_NT_VERSION, LDAP_NT_VERSION_LEN=
);
> +       // Bitmask NETLOGON_NT_VERSION_5 & NETLOGON_NT_VERSION_5EX -> To =
get NETLOGON_SAM_LOGON_RESPONSE_EX as response
> +       asn1_write_OctetString(data, "\x06\x00\x00\x00", 4);
> +       asn1_pop_tag(data);
> +
> +       // End AND
> +       asn1_pop_tag(data);
> +
> +       asn1_push_tag(data, ASN1_SEQUENCE(0));
> +       asn1_write_OctetString(data, LDAP_ATTRIBUTE_NETLOGON, LDAP_ATTRIB=
UTE_NETLOGON_LEN);
> +       asn1_pop_tag(data);
> +
> +       // End SearchRequest
> +       asn1_pop_tag(data);
> +       // End Sequence
> +       asn1_pop_tag(data);
> +
> +       return data;
> +}
> +
> +// Input is a cldap response, output is a pointer to the NETLOGON_SAM_LO=
GON_RESPONSE_EX payload
> +ssize_t extract_netlogon_section(char *buffer, size_t buffer_size, char =
**netlogon_payload) {
> +       size_t ber_size;
> +       size_t netlogon_payload_size;
> +       // Not enough space to read initial sequence - not an correct cld=
ap response
> +       if (buffer_size < 7) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       // Sequence tag
> +       if (*buffer !=3D 0x30) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       char *message_id_tag =3D parse_ber_size(buffer + 1, &ber_size);
> +
> +       if (ber_size > buffer_size) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       if (*message_id_tag !=3D 0x02) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       char *message_id =3D parse_ber_size(message_id_tag + 1, &ber_size=
);
> +
> +       if (ber_size !=3D 1 || *message_id !=3D 1) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       // SearchResultEntry
> +       if (*(message_id+1) !=3D 0x64) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       char *object_name_tag =3D parse_ber_size(message_id+2, &ber_size)=
;
> +       if (object_name_tag =3D=3D NULL) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       char *object_name =3D parse_ber_size(object_name_tag+1, &ber_size=
);
> +       if (object_name =3D=3D NULL) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       if (*object_name_tag !=3D 4 || ber_size !=3D 0) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       char *partial_attribute_list_tag =3D parse_ber_size(object_name+1=
, &ber_size);
> +       if (partial_attribute_list_tag =3D=3D NULL) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       if (*partial_attribute_list_tag !=3D 0x30) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +
> +       char *partial_attribute_tag =3D parse_ber_size(partial_attribute_=
list_tag+1, &ber_size);
> +       if (partial_attribute_tag =3D=3D NULL) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       char *attribute_name =3D parse_ber_size(partial_attribute_tag+1, =
&ber_size);
> +       if (attribute_name =3D=3D NULL) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       if (ber_size !=3D LDAP_ATTRIBUTE_NETLOGON_LEN) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       if (strncasecmp(LDAP_ATTRIBUTE_NETLOGON, attribute_name, LDAP_ATT=
RIBUTE_NETLOGON_LEN) !=3D 0) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       // SET
> +       if (*(attribute_name+LDAP_ATTRIBUTE_NETLOGON_LEN) !=3D 0x31) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       char *start_of_data =3D parse_ber_size(attribute_name+LDAP_ATTRIB=
UTE_NETLOGON_LEN+1, &ber_size);
> +       if (start_of_data =3D=3D NULL) {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       // octat-string of NetLogon data
> +       if (*start_of_data !=3D '\x04') {
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       *netlogon_payload =3D parse_ber_size(start_of_data + 1, &netlogon=
_payload_size);
> +
> +       if (*netlogon_payload =3D=3D NULL) {
> +               *netlogon_payload =3D NULL;
> +               return CLDAP_PING_PARSE_ERROR_LDAP;
> +       }
> +
> +       return (ssize_t)netlogon_payload_size;
> +}
> +
> +int netlogon_get_client_site(char *netlogon_response, size_t netlogon_si=
ze, char *sitename) {
> +       // 24 mandatory bytes
> +       if (netlogon_size < 25) {
> +               return CLDAP_PING_PARSE_ERROR_NETLOGON;
> +       }
> +
> +       // LOGON_SAM_PAUSE_RESPONSE_EX -> Netlogon service is not in-sync=
 try next dc instead
> +       if (*netlogon_response =3D=3D 0x18 && *(netlogon_response + 1) =
=3D=3D 0x00) {
> +               return CLDAP_PING_TRYNEXT;
> +       }
> +
> +       // NETLOGON_SAM_LOGON_RESPONSE_EX Opcode: 0x17
> +       if (*netlogon_response !=3D 0x17 || *(netlogon_response + 1) !=3D=
 0x00) {
> +               return CLDAP_PING_PARSE_ERROR_NETLOGON;
> +       }
> +
> +       // skip over sbz, ds_flags and domain_guid
> +       // and start directly at variable string portion of NETLOGON_SAM_=
LOGON_RESPONSE_EX
> +       size_t offset =3D 24;
> +
> +       for (int i=3D0; i < 8; i++) {
> +               // iterate over DnsForestName, DnsDomainName, NetbiosDoma=
inName, NetbiosComputerName, UserName, DcSiteName
> +               // to finally get to our desired ClientSiteName field
> +               if (read_dns_string(netlogon_response, netlogon_size, sit=
ename, MAXCDNAME, &offset) < 0) {
> +                       return CLDAP_PING_PARSE_ERROR_NETLOGON;
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +int cldap_ping(char *domain, sa_family_t family, void *addr, char *site_=
name) {
> +       char buffer[8196];
> +       ssize_t response_size;
> +       char *netlogon_response;
> +       ssize_t netlogon_size;
> +       struct sockaddr_storage socketaddr;
> +       size_t addr_size;
> +       int sock =3D socket(family, SOCK_DGRAM, 0);
> +       if (sock < 0) {
> +               return CLDAP_PING_NETWORK_ERROR;
> +       }
> +
> +       ASN1_DATA *data =3D generate_cldap_query(domain);
> +
> +       if (family =3D=3D AF_INET6) {
> +               addr_size =3D sizeof(struct sockaddr_in6);
> +               bzero((void *) &socketaddr, addr_size);
> +               socketaddr.ss_family =3D AF_INET6;
> +               ((struct sockaddr_in6 *)&socketaddr)->sin6_addr =3D *((st=
ruct in6_addr*)addr);
> +               ((struct sockaddr_in6 *)&socketaddr)->sin6_port =3D htons=
(389);
> +       } else {
> +               addr_size =3D sizeof(struct sockaddr_in);
> +               bzero((void *) &socketaddr, addr_size);
> +               socketaddr.ss_family =3D AF_INET;
> +               ((struct sockaddr_in *)&socketaddr)->sin_addr =3D *((stru=
ct in_addr*)addr);
> +               ((struct sockaddr_in *)&socketaddr)->sin_port =3D htons(3=
89);
> +       }
> +
> +       struct timeval timeout =3D {.tv_sec =3D 2, .tv_usec =3D 0};
> +       if (setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(ti=
meout)) < 0) {
> +               return CLDAP_PING_NETWORK_ERROR;
> +       }
> +       if (setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(ti=
meout)) < 0) {
> +               return CLDAP_PING_NETWORK_ERROR;
> +       }
> +
> +       if (sendto(sock, data->data, data->length, 0, (struct sockaddr *)=
&socketaddr, addr_size) < 0) {
> +               close(sock);
> +               return CLDAP_PING_TRYNEXT;
> +       }
> +
> +       asn1_free(data);
> +       response_size =3D recv(sock, buffer, sizeof(buffer), 0);
> +       close(sock);
> +
> +       if (response_size < 0) {
> +               return CLDAP_PING_TRYNEXT;
> +       }
> +
> +       netlogon_size =3D extract_netlogon_section(buffer, response_size,=
 &netlogon_response);
> +       if (netlogon_size < 0) {
> +               return (int)netlogon_size;
> +       }
> +
> +       return netlogon_get_client_site(netlogon_response, netlogon_size,=
 site_name);
> +}
> +
> diff --git a/cldap_ping.h b/cldap_ping.h
> new file mode 100644
> index 0000000..9a23e72
> --- /dev/null
> +++ b/cldap_ping.h
> @@ -0,0 +1,14 @@
> +#ifndef _CLDAP_PING_H_
> +#define _CLDAP_PING_H_
> +
> +#define CLDAP_PING_NETWORK_ERROR -1
> +#define CLDAP_PING_TRYNEXT -2
> +#define CLDAP_PING_PARSE_ERROR_LDAP -3
> +#define CLDAP_PING_PARSE_ERROR_NETLOGON -4
> +
> +// returns CLDAP_PING_TRYNEXT if you should use another dc
> +// any other error code < 0 is a fatal error
> +// site_name must be of MAXCDNAME size!
> +int cldap_ping(char *domain, sa_family_t family, void *addr, char *site_=
name);
> +
> +#endif /* _CLDAP_PING_H_ */
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 2278995..3b7a6b3 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -1889,8 +1889,11 @@ assemble_mountinfo(struct parsed_mount_info *parse=
d_info,
>         if (rc)
>                 goto assemble_exit;
>
> -       if (parsed_info->addrlist[0] =3D=3D '\0')
> +       if (parsed_info->addrlist[0] =3D=3D '\0') {
>                 rc =3D resolve_host(parsed_info->host, parsed_info->addrl=
ist);
> +               if (rc =3D=3D 0 && parsed_info->verboseflag)
> +                       fprintf(stderr, "Host \"%s\" resolved to the foll=
owing IP addresses: %s\n", parsed_info->host, parsed_info->addrlist);
> +       }
>
>         switch (rc) {
>         case EX_USAGE:
> diff --git a/resolve_host.c b/resolve_host.c
> index 17cbd10..8c0303f 100644
> --- a/resolve_host.c
> +++ b/resolve_host.c
> @@ -3,6 +3,7 @@
>   *
>   * Copyright (C) 2010 Jeff Layton (jlayton@samba.org)
>   * Copyright (C) 2010 Igor Druzhinin (jaxbrigs@gmail.com)
> + * Copyright (C) 2024 David Voit (david.voit@gmail.com)
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
> @@ -27,15 +28,16 @@
>  #include <sys/socket.h>
>  #include <arpa/inet.h>
>  #include <netdb.h>
> +#include <resolv.h>
>  #include "mount.h"
>  #include "util.h"
> +#include "cldap_ping.h"
>  #include "resolve_host.h"
>
>  /*
>   * resolve hostname to comma-separated list of address(es)
>   */
> -int resolve_host(const char *host, char *addrstr)
> -{
> +int resolve_host(const char *host, char *addrstr) {
>         int rc;
>         /* 10 for max width of decimal scopeid */
>         char tmpbuf[NI_MAXHOST + 1 + 10 + 1];
> @@ -44,6 +46,7 @@ int resolve_host(const char *host, char *addrstr)
>         struct addrinfo *addrlist, *addr;
>         struct sockaddr_in *sin;
>         struct sockaddr_in6 *sin6;
> +       size_t count_v4 =3D 0, count_v6 =3D 0;
>
>         rc =3D getaddrinfo(host, NULL, NULL, &addrlist);
>         if (rc !=3D 0)
> @@ -53,40 +56,51 @@ int resolve_host(const char *host, char *addrstr)
>         while (addr) {
>                 /* skip non-TCP entries */
>                 if (addr->ai_socktype !=3D SOCK_STREAM ||
> -                   addr->ai_protocol !=3D IPPROTO_TCP) {
> +                       addr->ai_protocol !=3D IPPROTO_TCP) {
>                         addr =3D addr->ai_next;
>                         continue;
>                 }
>
>                 switch (addr->ai_addr->sa_family) {
> -               case AF_INET6:
> -                       sin6 =3D (struct sockaddr_in6 *)addr->ai_addr;
> -                       ipaddr =3D inet_ntop(AF_INET6, &sin6->sin6_addr, =
tmpbuf,
> -                                          sizeof(tmpbuf));
> -                       if (!ipaddr) {
> -                               rc =3D EX_SYSERR;
> -                               goto resolve_host_out;
> -                       }
> +                       case AF_INET6:
> +                               count_v6++;
> +                               if (count_v6 + count_v4 > MAX_ADDRESSES) =
{
> +                                       addr =3D addr->ai_next;
> +                                       continue;
> +                               }
>
> -                       if (sin6->sin6_scope_id) {
> -                               len =3D strnlen(tmpbuf, sizeof(tmpbuf));
> -                               snprintf(tmpbuf + len, sizeof(tmpbuf) - l=
en, "%%%u",
> -                                        sin6->sin6_scope_id);
> -                       }
> -                       break;
> -               case AF_INET:
> -                       sin =3D (struct sockaddr_in *)addr->ai_addr;
> -                       ipaddr =3D inet_ntop(AF_INET, &sin->sin_addr, tmp=
buf,
> -                                          sizeof(tmpbuf));
> -                       if (!ipaddr) {
> -                               rc =3D EX_SYSERR;
> -                               goto resolve_host_out;
> -                       }
> +                               sin6 =3D (struct sockaddr_in6 *) addr->ai=
_addr;
> +                               ipaddr =3D inet_ntop(AF_INET6, &sin6->sin=
6_addr, tmpbuf,
> +                                                                  sizeof=
(tmpbuf));
> +                               if (!ipaddr) {
> +                                       rc =3D EX_SYSERR;
> +                                       goto resolve_host_out;
> +                               }
>
> -                       break;
> -               default:
> -                       addr =3D addr->ai_next;
> -                       continue;
> +
> +                               if (sin6->sin6_scope_id) {
> +                                       len =3D strnlen(tmpbuf, sizeof(tm=
pbuf));
> +                                       snprintf(tmpbuf + len, sizeof(tmp=
buf) - len, "%%%u",
> +                                                        sin6->sin6_scope=
_id);
> +                               }
> +                               break;
> +                       case AF_INET:
> +                               count_v4++;
> +                               if (count_v6 + count_v4 > MAX_ADDRESSES) =
{
> +                                       addr =3D addr->ai_next;
> +                                       continue;
> +                               }
> +                               sin =3D (struct sockaddr_in *) addr->ai_a=
ddr;
> +                               ipaddr =3D inet_ntop(AF_INET, &sin->sin_a=
ddr, tmpbuf,
> +                                                                  sizeof=
(tmpbuf));
> +                               if (!ipaddr) {
> +                                       rc =3D EX_SYSERR;
> +                                       goto resolve_host_out;
> +                               }
> +                               break;
> +                       default:
> +                               addr =3D addr->ai_next;
> +                               continue;
>                 }
>
>                 if (addr =3D=3D addrlist)
> @@ -98,6 +112,192 @@ int resolve_host(const char *host, char *addrstr)
>                 addr =3D addr->ai_next;
>         }
>
> +
> +       // Is this a DFS domain where we need to do a cldap ping to find =
the closest node?
> +       if (count_v4 > 1 || count_v6 > 1) {
> +               int res;
> +               ns_msg global_domain_handle;
> +               unsigned char global_domain_lookup[4096];
> +               ns_msg site_domain_handle;
> +               unsigned char site_domain_lookup[4096];
> +               char dname[MAXCDNAME];
> +               int srv_cnt;
> +
> +               res =3D res_init();
> +               if (res !=3D 0)
> +                       goto resolve_host_out;
> +
> +               res =3D snprintf(dname, MAXCDNAME, "_ldap._tcp.dc._msdcs.=
%s", host);
> +               if (res < 0)
> +                       goto resolve_host_out;
> +
> +               res =3D res_query(dname, C_IN, ns_t_srv, global_domain_lo=
okup, sizeof(global_domain_lookup));
> +               if (res < 0)
> +                       goto resolve_host_out;
> +
> +               // res is also the size of the response_buffer
> +               res =3D ns_initparse(global_domain_lookup, res, &global_d=
omain_handle);
> +               if (res < 0)
> +                       goto resolve_host_out;
> +
> +               srv_cnt =3D ns_msg_count (global_domain_handle, ns_s_an);
> +
> +               // No or just one DC we are done
> +               if (srv_cnt < 2)
> +                       goto resolve_host_out;
> +
> +               char site_name[MAXCDNAME];
> +               // We assume that AD always sends the ip addresses in the=
 addtional data block
> +               for (int i =3D 0; i < ns_msg_count(global_domain_handle, =
ns_s_ar); i++) {
> +                       ns_rr rr;
> +                       res =3D ns_parserr(&global_domain_handle, ns_s_ar=
, i, &rr);
> +                       if (res < 0)
> +                               goto resolve_host_out;
> +
> +                       switch (ns_rr_type(rr)) {
> +                               case ns_t_aaaa:
> +                                       if (ns_rr_rdlen(rr) !=3D NS_IN6AD=
DRSZ)
> +                                               continue;
> +                                       res =3D cldap_ping((char *) host,=
 AF_INET6, (void *)ns_rr_rdata(rr), site_name);
> +                                       break;
> +                               case ns_t_a:
> +                                       if (ns_rr_rdlen(rr) !=3D NS_INADD=
RSZ)
> +                                               continue;
> +                                       res =3D cldap_ping((char *) host,=
 AF_INET, (void *)ns_rr_rdata(rr), site_name);
> +                                       break;
> +                               default:
> +                                       continue;
> +                       }
> +
> +                       if (res =3D=3D CLDAP_PING_TRYNEXT) {
> +                               continue;
> +                       }
> +
> +                       if (res < 0) {
> +                               goto resolve_host_out;
> +                       }
> +
> +                       if (site_name[0] =3D=3D '\0') {
> +                               goto resolve_host_out;
> +                       } else {
> +                               // site found - leave loop
> +                               break;
> +                       }
> +               }
> +
> +               res =3D snprintf(dname, MAXCDNAME, "_ldap._tcp.%s._sites.=
dc._msdcs.%s", site_name, host);
> +               if (res < 0) {
> +                       goto resolve_host_out;
> +               }
> +
> +               res =3D res_query(dname, C_IN, ns_t_srv, site_domain_look=
up, sizeof(site_domain_lookup));
> +               if (res < 0)
> +                       goto resolve_host_out;
> +
> +               // res is also the size of the response_buffer
> +               res =3D ns_initparse(site_domain_lookup, res, &site_domai=
n_handle);
> +               if (res < 0)
> +                       goto resolve_host_out;
> +
> +               int number_addresses =3D 0;
> +               for (int i =3D 0; i < ns_msg_count(site_domain_handle, ns=
_s_ar); i++) {
> +                       if (i > MAX_ADDRESSES)
> +                               break;
> +
> +                       ns_rr rr;
> +                       res =3D ns_parserr(&site_domain_handle, ns_s_ar, =
i, &rr);
> +                       if (res < 0)
> +                               goto resolve_host_out;
> +
> +                       switch (ns_rr_type(rr)) {
> +                               case ns_t_aaaa:
> +                                       if (ns_rr_rdlen(rr) !=3D NS_IN6AD=
DRSZ)
> +                                               continue;
> +                                       ipaddr =3D inet_ntop(AF_INET6, ns=
_rr_rdata(rr), tmpbuf,
> +                                                                        =
  sizeof(tmpbuf));
> +                                       if (!ipaddr) {
> +                                               rc =3D EX_SYSERR;
> +                                               goto resolve_host_out;
> +                                       }
> +                                       break;
> +                               case ns_t_a:
> +                                       if (ns_rr_rdlen(rr) !=3D NS_INADD=
RSZ)
> +                                               continue;
> +                                       ipaddr =3D inet_ntop(AF_INET, ns_=
rr_rdata(rr), tmpbuf,
> +                                                                        =
  sizeof(tmpbuf));
> +                                       if (!ipaddr) {
> +                                               rc =3D EX_SYSERR;
> +                                               goto resolve_host_out;
> +                                       }
> +                                       break;
> +                               default:
> +                                       continue;
> +                       }
> +
> +                       number_addresses++;
> +
> +                       if (i =3D=3D 0)
> +                               *addrstr =3D '\0';
> +                       else
> +                               strlcat(addrstr, ",", MAX_ADDR_LIST_LEN);
> +
> +                       strlcat(addrstr, tmpbuf, MAX_ADDR_LIST_LEN);
> +               }
> +
> +               // Preferred site ips is now the first entry in addrstr, =
fill up with other sites till MAX_ADDRESS
> +               for (int i =3D 0; i < ns_msg_count(global_domain_handle, =
ns_s_ar); i++) {
> +                       if (number_addresses > MAX_ADDRESSES)
> +                               break;
> +
> +                       ns_rr rr;
> +                       res =3D ns_parserr(&global_domain_handle, ns_s_ar=
, i, &rr);
> +                       if (res < 0)
> +                               goto resolve_host_out;
> +
> +                       switch (ns_rr_type(rr)) {
> +                               case ns_t_aaaa:
> +                                       if (ns_rr_rdlen(rr) !=3D NS_IN6AD=
DRSZ)
> +                                               continue;
> +                                       ipaddr =3D inet_ntop(AF_INET6, ns=
_rr_rdata(rr), tmpbuf,
> +                                                                        =
  sizeof(tmpbuf));
> +                                       if (!ipaddr) {
> +                                               rc =3D EX_SYSERR;
> +                                               goto resolve_host_out;
> +                                       }
> +                                       break;
> +                               case ns_t_a:
> +                                       if (ns_rr_rdlen(rr) !=3D NS_INADD=
RSZ)
> +                                               continue;
> +                                       ipaddr =3D inet_ntop(AF_INET, ns_=
rr_rdata(rr), tmpbuf,
> +                                                                        =
  sizeof(tmpbuf));
> +                                       if (!ipaddr) {
> +                                               rc =3D EX_SYSERR;
> +                                               goto resolve_host_out;
> +                                       }
> +                                       break;
> +                               default:
> +                                       continue;
> +                       }
> +
> +                       char *found =3D strstr(addrstr, tmpbuf);
> +
> +                       if (found) {
> +                               // We only have a real match if the subst=
ring is between  ',' or it's the last/first entry in the list
> +                               char previous_seperator =3D found > addrs=
tr ? *(found-1) : '\0';
> +                               char next_seperator =3D *(found+strlen(tm=
pbuf));
> +
> +                               if ((next_seperator =3D=3D ',' || next_se=
perator =3D=3D '\0')
> +                                       && (previous_seperator =3D=3D ','=
 || previous_seperator =3D=3D '\0')) {
> +                                       continue;
> +                               }
> +                       }
> +
> +                       number_addresses++;
> +                       strlcat(addrstr, ",", MAX_ADDR_LIST_LEN);
> +                       strlcat(addrstr, tmpbuf, MAX_ADDR_LIST_LEN);
> +               }
> +       }
> +
>  resolve_host_out:
>         freeaddrinfo(addrlist);
>         return rc;
> diff --git a/resolve_host.h b/resolve_host.h
> index b949245..f2b19e6 100644
> --- a/resolve_host.h
> +++ b/resolve_host.h
> @@ -26,8 +26,10 @@
>  /* currently maximum length of IPv6 address string */
>  #define MAX_ADDRESS_LEN INET6_ADDRSTRLEN
>
> -/* limit list of addresses to 16 max-size addrs */
> -#define MAX_ADDR_LIST_LEN ((MAX_ADDRESS_LEN + 1) * 16)
> +#define MAX_ADDRESSES 16
> +
> +/* limit list of addresses to MAX_ADDRESSES max-size addrs */
> +#define MAX_ADDR_LIST_LEN ((MAX_ADDRESS_LEN + 1) * MAX_ADDRESSES)
>
>  extern int resolve_host(const char *host, char *addrstr);
>
> --
> 2.44.0
>
>

