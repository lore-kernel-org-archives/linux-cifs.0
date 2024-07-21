Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145E2C8C7
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jul 2024 21:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721595673; cv=none; b=VhglZRvx8iVklYoOK2OWGm3eYvonsV+R4h7a5+R8OwXHZhDwW6QMaYWMwhpcQYdFMqQctotGPQuhgK7Af4dSk8e2cLWxYfMZIf4zds8vrqqHTMoCdKGvuOwOwYW58gF+m1zKWLUOKAA8ujnjm29xfgXYGQubzgGoXV+bCwxwMt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721595673; c=relaxed/simple;
	bh=Ra/bzXlBwNuVSdje2dq0Vtcqz2DWyKv7z256en6Dvck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=trO3o+pfJavWjJ7iS7RfgM1hRiOjHNcEXEIBCCpU9t47lelUiPu5owdgGebbRiynUdrH6nYhHiQBPZODA9ufx0qnPHPWFjH/LIixk8YbIZuJqP3KNEBI0JXL15uHv5ea5HTzNqqVKZWwamM+lJ29ygQluaX3qGVnGsYKpYiNEAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SgeDjogU; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SgeDjogU"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2ee9b098bd5so47414431fa.0
        for <linux-cifs@vger.kernel.org>; Sun, 21 Jul 2024 14:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721595669; x=1722200469; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fz+6GWF+0CjNnmHQ6qKRpu2hTQk6UtJFg6kMA9l4CK8=;
        b=SgeDjogUHjoxKHSvSpFaptrH8ZOLAle4liVIx7E+oLkGaumBpF1ZxjJA3D8uqEv8vn
         N0h5bue7AJEMjij23Rh8l7W0MLG59Tl3G2RrKxGxku+OTKMPR+YvdbkZaCfVNuwWrpHM
         0lD2tRHTC31RJZittEjIv+/JELF5BuQBBwJ7OD/G4C3ebmpdD/FQxBE0M9VWC8lMfBm4
         AICH6uBl05HQQDzmSCBQkfegV8N5UnMmdqH/eW8XcTsZCsmbDR1DNjg0agjIZ9QDoZNY
         364WHYIbjMlH19dD2Ed8bR8mhjbCQVyCGeLnRqbAPJbhQEwlVtMNtmlf9rOeVmOkMyqF
         brNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721595669; x=1722200469;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fz+6GWF+0CjNnmHQ6qKRpu2hTQk6UtJFg6kMA9l4CK8=;
        b=eZv/mjZ/m3hY8N0Ksf0nVn7AKrqt5XPVPsHIPyMXY6kXFSN3IjBhdtqSsBLHZjehZu
         pllaSK4+oz0MkEC6s2kfzppbWKc9WnDlYOlMUL59QJGQ2cEaCxQQoGSW30BGCn/cQOxT
         ijAvdU+ksOOtwjU5rcfPOfsqI+m91YcL41llIIrDkUv4nH8Q2nOknJNpowAWov8dLb66
         l4ygSrXmg+90bNIF7LuILSr/7XESrdSY5Lbb+nSbcrGB3F/i9HTVuItayaONGTWTnxiD
         4c1oFz7p4Rxd+B9o4vEJ+UbDVh6gQr01dbW6QHCY5WqKu0dM5uwNriP6rJWX4sMbDq0c
         fIxA==
X-Forwarded-Encrypted: i=1; AJvYcCWqMB9Ahw2d5k+SgvcMEkWeDxOOdmw1oaL10Z51ZEnI8Xj2RpFK2Xdjz3w5RnQgEVTgrmddK1vfMnWHPnbXQkMgvzIV7XG9EyDNTQ==
X-Gm-Message-State: AOJu0YyN4OgC7d6jKILl2lSuOHyCCOqQ6BGBshVb02ScnvucqbhsIiRN
	hokgncq/I6OuHqWqj9tGAuBiyy86vIpBmEb2EUitA/L5VXQMVfbJIRWoC4VpcPbr4Xrnsqlz7SK
	GApwhbf/2acf5CNUVbv8bwoL6+fc=
X-Google-Smtp-Source: AGHT+IH83q8bUxumYzCrFMfqb9eEs1J3VHeMjiXto1geZ+t50yjmR4URJQ6PV9FOW4muZGRu1JGqJzlRoqA0hwyaEDA=
X-Received: by 2002:a05:6512:1322:b0:52c:e0e1:9ae3 with SMTP id
 2adb3069b0e04-52efb851b4amr3068027e87.57.1721595668773; Sun, 21 Jul 2024
 14:01:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6487f3bc-102c-40a0-96ec-dd97dc00c49c@stanley.mountain>
In-Reply-To: <6487f3bc-102c-40a0-96ec-dd97dc00c49c@stanley.mountain>
From: Steve French <smfrench@gmail.com>
Date: Sun, 21 Jul 2024 16:00:57 -0500
Message-ID: <CAH2r5muSF5S3D683evO4V6=EANqXbeC_HZ+ywPb_12aUDQ53yg@mail.gmail.com>
Subject: Re: [bug report] smb3: retrying on failed server close
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Ritvik Budhiraja <rbudhiraja@microsoft.com>, linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000048e181061dc83a5f"

--00000000000048e181061dc83a5f
Content-Type: multipart/alternative; boundary="00000000000048e180061dc83a5d"

--00000000000048e180061dc83a5d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This should be the simpler way to fix this, which matches the unwind
ladder.   I moved the goto label to the
correct place so the frees are in the right order and switched the two
gotos which were backwards.

Let me know if any objections or additional cleanup you think is important.

On Fri, Jul 19, 2024 at 5:05=E2=80=AFPM Dan Carpenter <dan.carpenter@linaro=
.org>
wrote:

> Hello Ritvik Budhiraja,
>
> Commit 173217bd7336 ("smb3: retrying on failed server close") from
> Apr 2, 2024 (linux-next), leads to the following Smatch static
> checker warning:
>
>         fs/smb/client/cifsfs.c:1981 init_cifs()
>         error: we previously assumed 'serverclose_wq' could be null (see
> line 1895)
>
> I've written a blog about best practices for how kernel unwind ladders ar=
e
> normally written.
>
> https://staticthinking.wordpress.com/2022/04/28/free-the-last-thing-style=
/
>
> fs/smb/client/cifsfs.c
>   1800  static int __init
>   1801  init_cifs(void)
>   1802  {
>   1803          int rc =3D 0;
>   1804          cifs_proc_init();
>
> This creates proc files.
>
>   1805          INIT_LIST_HEAD(&cifs_tcp_ses_list);
>   1806  /*
>   1807   *  Initialize Global counters
>   1808   */
>   1809          atomic_set(&sesInfoAllocCount, 0);
>   1810          atomic_set(&tconInfoAllocCount, 0);
>   1811          atomic_set(&tcpSesNextId, 0);
>   1812          atomic_set(&tcpSesAllocCount, 0);
>   1813          atomic_set(&tcpSesReconnectCount, 0);
>   1814          atomic_set(&tconInfoReconnectCount, 0);
>   1815
>   1816          atomic_set(&buf_alloc_count, 0);
>   1817          atomic_set(&small_buf_alloc_count, 0);
>   1818  #ifdef CONFIG_CIFS_STATS2
>   1819          atomic_set(&total_buf_alloc_count, 0);
>   1820          atomic_set(&total_small_buf_alloc_count, 0);
>   1821          if (slow_rsp_threshold < 1)
>   1822                  cifs_dbg(FYI, "slow_response_threshold msgs
> disabled\n");
>   1823          else if (slow_rsp_threshold > 32767)
>   1824                  cifs_dbg(VFS,
>   1825                         "slow response threshold set higher than
> recommended (0 to 32767)\n");
>   1826  #endif /* CONFIG_CIFS_STATS2 */
>   1827
>   1828          atomic_set(&mid_count, 0);
>   1829          GlobalCurrentXid =3D 0;
>   1830          GlobalTotalActiveXid =3D 0;
>   1831          GlobalMaxActiveXid =3D 0;
>   1832          spin_lock_init(&cifs_tcp_ses_lock);
>   1833          spin_lock_init(&GlobalMid_Lock);
>   1834
>   1835          cifs_lock_secret =3D get_random_u32();
>   1836
>   1837          if (cifs_max_pending < 2) {
>   1838                  cifs_max_pending =3D 2;
>   1839                  cifs_dbg(FYI, "cifs_max_pending set to min of
> 2\n");
>   1840          } else if (cifs_max_pending > CIFS_MAX_REQ) {
>   1841                  cifs_max_pending =3D CIFS_MAX_REQ;
>   1842                  cifs_dbg(FYI, "cifs_max_pending set to max of
> %u\n",
>   1843                           CIFS_MAX_REQ);
>   1844          }
>   1845
>   1846          /* Limit max to about 18 hours, and setting to zero
> disables directory entry caching */
>   1847          if (dir_cache_timeout > 65000) {
>   1848                  dir_cache_timeout =3D 65000;
>   1849                  cifs_dbg(VFS, "dir_cache_timeout set to max of
> 65000 seconds\n");
>   1850          }
>   1851
>   1852          cifsiod_wq =3D alloc_workqueue("cifsiod",
> WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
>   1853          if (!cifsiod_wq) {
>   1854                  rc =3D -ENOMEM;
>   1855                  goto out_clean_proc;
>
> Generally I can tell from these gotos that they free the last resource.
> This
> one deletes the proc files.
>
>   1856          }
>   1857
>   1858          /*
>   1859           * Consider in future setting limit!=3D0 maybe to
> min(num_of_cores - 1, 3)
>   1860           * so that we don't launch too many worker threads but
>   1861           * Documentation/core-api/workqueue.rst recommends settin=
g
> it to 0
>   1862           */
>   1863
>   1864          /* WQ_UNBOUND allows decrypt tasks to run on any CPU */
>   1865          decrypt_wq =3D alloc_workqueue("smb3decryptd",
>   1866
>  WQ_UNBOUND|WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
>   1867          if (!decrypt_wq) {
>   1868                  rc =3D -ENOMEM;
>   1869                  goto out_destroy_cifsiod_wq;
>
> cifsiod_wq alloc and destroyed.  Fine.
>
>   1870          }
>   1871
>   1872          fileinfo_put_wq =3D alloc_workqueue("cifsfileinfoput",
>   1873
>  WQ_UNBOUND|WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
>   1874          if (!fileinfo_put_wq) {
>   1875                  rc =3D -ENOMEM;
>   1876                  goto out_destroy_decrypt_wq;
>   1877          }
>   1878
>   1879          cifsoplockd_wq =3D alloc_workqueue("cifsoplockd",
>   1880
>  WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
>   1881          if (!cifsoplockd_wq) {
>   1882                  rc =3D -ENOMEM;
>   1883                  goto out_destroy_fileinfo_put_wq;
>   1884          }
>   1885
>   1886          deferredclose_wq =3D alloc_workqueue("deferredclose",
>   1887
>  WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
>   1888          if (!deferredclose_wq) {
>   1889                  rc =3D -ENOMEM;
>   1890                  goto out_destroy_cifsoplockd_wq;
>   1891          }
>   1892
>   1893          serverclose_wq =3D alloc_workqueue("serverclose",
>   1894
>  WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
>   1895          if (!serverclose_wq) {
>   1896                  rc =3D -ENOMEM;
>   1897                  goto out_destroy_serverclose_wq;
>
> This should be goto out_destroy_deferredclose_wq.
>
>   1898          }
>   1899
>   1900          rc =3D cifs_init_inodecache();
>   1901          if (rc)
>   1902                  goto out_destroy_deferredclose_wq;
>
> This should be out_destroy_serverclose_wq.
>
>   1903
>   1904          rc =3D cifs_init_netfs();
>   1905          if (rc)
>   1906                  goto out_destroy_inodecache;
>   1907
>   1908          rc =3D init_mids();
>   1909          if (rc)
>   1910                  goto out_destroy_netfs;
>   1911
>   1912          rc =3D cifs_init_request_bufs();
>   1913          if (rc)
>   1914                  goto out_destroy_mids;
>   1915
>   1916  #ifdef CONFIG_CIFS_DFS_UPCALL
>   1917          rc =3D dfs_cache_init();
>   1918          if (rc)
>   1919                  goto out_destroy_request_bufs;
>   1920  #endif /* CONFIG_CIFS_DFS_UPCALL */
>   1921  #ifdef CONFIG_CIFS_UPCALL
>   1922          rc =3D init_cifs_spnego();
>   1923          if (rc)
>   1924                  goto out_destroy_dfs_cache;
>   1925  #endif /* CONFIG_CIFS_UPCALL */
>   1926  #ifdef CONFIG_CIFS_SWN_UPCALL
>   1927          rc =3D cifs_genl_init();
>   1928          if (rc)
>   1929                  goto out_register_key_type;
>
> This goto has a confusing name.  It calls exit_cifs_spnego().  It used to
> unregister the spegno key type.  #HistoricalReasons
>
>   1930  #endif /* CONFIG_CIFS_SWN_UPCALL */
>   1931
>   1932          rc =3D init_cifs_idmap();
>   1933          if (rc)
>   1934                  goto out_cifs_swn_init;
>   1935
>   1936          rc =3D register_filesystem(&cifs_fs_type);
>   1937          if (rc)
>   1938                  goto out_init_cifs_idmap;
>   1939
>   1940          rc =3D register_filesystem(&smb3_fs_type);
>   1941          if (rc) {
>   1942                  unregister_filesystem(&cifs_fs_type);
>
> Do this in the unwind ladder, not before the goto.
>
>   1943                  goto out_init_cifs_idmap;
>   1944          }
>   1945
>   1946          return 0;
>   1947
>   1948  out_init_cifs_idmap:
>   1949          exit_cifs_idmap();
>   1950  out_cifs_swn_init:
>   1951  #ifdef CONFIG_CIFS_SWN_UPCALL
>   1952          cifs_genl_exit();
>   1953  out_register_key_type:
>   1954  #endif
>   1955  #ifdef CONFIG_CIFS_UPCALL
>   1956          exit_cifs_spnego();
>   1957  out_destroy_dfs_cache:
>   1958  #endif
>   1959  #ifdef CONFIG_CIFS_DFS_UPCALL
>   1960          dfs_cache_destroy();
>   1961  out_destroy_request_bufs:
>   1962  #endif
>
> These ifdef are a bit complicated.  It might be nicer to write it as:
>
> out_cifs_swn_init:
>         if (IS_ENABLED(CONFIG_CIFS_SWN_UPCALL))
>                 cifs_genl_exit();
>
>   1963          cifs_destroy_request_bufs();
>   1964  out_destroy_mids:
>   1965          destroy_mids();
>   1966  out_destroy_netfs:
>   1967          cifs_destroy_netfs();
>   1968  out_destroy_inodecache:
>   1969          cifs_destroy_inodecache();
>   1970  out_destroy_deferredclose_wq:
>   1971          destroy_workqueue(deferredclose_wq);
>   1972  out_destroy_cifsoplockd_wq:
>   1973          destroy_workqueue(cifsoplockd_wq);
>   1974  out_destroy_fileinfo_put_wq:
>   1975          destroy_workqueue(fileinfo_put_wq);
>   1976  out_destroy_decrypt_wq:
>   1977          destroy_workqueue(decrypt_wq);
>   1978  out_destroy_cifsiod_wq:
>   1979          destroy_workqueue(cifsiod_wq);
>   1980  out_destroy_serverclose_wq:
>   1981          destroy_workqueue(serverclose_wq);
>   1982  out_clean_proc:
>   1983          cifs_proc_clean();
>
> These need to be in mirror order from how they are allocated.  The last
> step is
> to cut and paste the cleanup into exit_cifs(), add an
> unregister_filesystem(&smb3_fs_type); and delete the labels.  There is an
> extra
> step of cifs_release_automount_timer() which kills the timer.  I would ha=
ve
> expected that to be the first thing in the function, but maybe the orderi=
ng
> doesn't matter or maybe I haven't understood how the ordering works.
>
>   1984          return rc;
>   1985  }
>
> regards,
> dan carpenter
>
>

--=20
Thanks,

Steve

--00000000000048e180061dc83a5d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+VGhpcyBzaG91bGQgYmUgdGhlIHNpbXBsZXIgd2F5IHRvIGZpeCB0aGlz
LCB3aGljaCBtYXRjaGVzIHRoZSB1bndpbmQgbGFkZGVyLsKgIMKgSSBtb3ZlZCB0aGUgZ290byBs
YWJlbCB0byB0aGU8ZGl2PmNvcnJlY3QgcGxhY2Ugc28gdGhlIGZyZWVzIGFyZSBpbiB0aGUgcmln
aHQgb3JkZXIgYW5kIHN3aXRjaGVkIHRoZSB0d28gZ290b3Mgd2hpY2ggd2VyZSBiYWNrd2FyZHMu
PC9kaXY+PGRpdj48YnI+PC9kaXY+PGRpdj5MZXQgbWUga25vdyBpZiBhbnkgb2JqZWN0aW9ucyBv
ciBhZGRpdGlvbmFswqBjbGVhbnVwIHlvdSB0aGluayBpcyBpbXBvcnRhbnQuPC9kaXY+PC9kaXY+
PGJyPjxkaXYgY2xhc3M9ImdtYWlsX3F1b3RlIj48ZGl2IGRpcj0ibHRyIiBjbGFzcz0iZ21haWxf
YXR0ciI+T24gRnJpLCBKdWwgMTksIDIwMjQgYXQgNTowNeKAr1BNIERhbiBDYXJwZW50ZXIgJmx0
OzxhIGhyZWY9Im1haWx0bzpkYW4uY2FycGVudGVyQGxpbmFyby5vcmciPmRhbi5jYXJwZW50ZXJA
bGluYXJvLm9yZzwvYT4mZ3Q7IHdyb3RlOjxicj48L2Rpdj48YmxvY2txdW90ZSBjbGFzcz0iZ21h
aWxfcXVvdGUiIHN0eWxlPSJtYXJnaW46MHB4IDBweCAwcHggMC44ZXg7Ym9yZGVyLWxlZnQ6MXB4
IHNvbGlkIHJnYigyMDQsMjA0LDIwNCk7cGFkZGluZy1sZWZ0OjFleCI+SGVsbG8gUml0dmlrIEJ1
ZGhpcmFqYSw8YnI+DQo8YnI+DQpDb21taXQgMTczMjE3YmQ3MzM2ICgmcXVvdDtzbWIzOiByZXRy
eWluZyBvbiBmYWlsZWQgc2VydmVyIGNsb3NlJnF1b3Q7KSBmcm9tPGJyPg0KQXByIDIsIDIwMjQg
KGxpbnV4LW5leHQpLCBsZWFkcyB0byB0aGUgZm9sbG93aW5nIFNtYXRjaCBzdGF0aWM8YnI+DQpj
aGVja2VyIHdhcm5pbmc6PGJyPg0KPGJyPg0KwqAgwqAgwqAgwqAgZnMvc21iL2NsaWVudC9jaWZz
ZnMuYzoxOTgxIGluaXRfY2lmcygpPGJyPg0KwqAgwqAgwqAgwqAgZXJyb3I6IHdlIHByZXZpb3Vz
bHkgYXNzdW1lZCAmIzM5O3NlcnZlcmNsb3NlX3dxJiMzOTsgY291bGQgYmUgbnVsbCAoc2VlIGxp
bmUgMTg5NSk8YnI+DQo8YnI+DQpJJiMzOTt2ZSB3cml0dGVuIGEgYmxvZyBhYm91dCBiZXN0IHBy
YWN0aWNlcyBmb3IgaG93IGtlcm5lbCB1bndpbmQgbGFkZGVycyBhcmU8YnI+DQpub3JtYWxseSB3
cml0dGVuLjxicj4NCjxicj4NCjxhIGhyZWY9Imh0dHBzOi8vc3RhdGljdGhpbmtpbmcud29yZHBy
ZXNzLmNvbS8yMDIyLzA0LzI4L2ZyZWUtdGhlLWxhc3QtdGhpbmctc3R5bGUvIiByZWw9Im5vcmVm
ZXJyZXIiIHRhcmdldD0iX2JsYW5rIj5odHRwczovL3N0YXRpY3RoaW5raW5nLndvcmRwcmVzcy5j
b20vMjAyMi8wNC8yOC9mcmVlLXRoZS1sYXN0LXRoaW5nLXN0eWxlLzwvYT48YnI+DQo8YnI+DQpm
cy9zbWIvY2xpZW50L2NpZnNmcy5jPGJyPg0KwqAgMTgwMMKgIHN0YXRpYyBpbnQgX19pbml0PGJy
Pg0KwqAgMTgwMcKgIGluaXRfY2lmcyh2b2lkKTxicj4NCsKgIDE4MDLCoCB7PGJyPg0KwqAgMTgw
M8KgIMKgIMKgIMKgIMKgIGludCByYyA9IDA7PGJyPg0KwqAgMTgwNMKgIMKgIMKgIMKgIMKgIGNp
ZnNfcHJvY19pbml0KCk7PGJyPg0KPGJyPg0KVGhpcyBjcmVhdGVzIHByb2MgZmlsZXMuPGJyPg0K
PGJyPg0KwqAgMTgwNcKgIMKgIMKgIMKgIMKgIElOSVRfTElTVF9IRUFEKCZhbXA7Y2lmc190Y3Bf
c2VzX2xpc3QpOzxicj4NCsKgIDE4MDbCoCAvKjxicj4NCsKgIDE4MDfCoCDCoCrCoCBJbml0aWFs
aXplIEdsb2JhbCBjb3VudGVyczxicj4NCsKgIDE4MDjCoCDCoCovPGJyPg0KwqAgMTgwOcKgIMKg
IMKgIMKgIMKgIGF0b21pY19zZXQoJmFtcDtzZXNJbmZvQWxsb2NDb3VudCwgMCk7PGJyPg0KwqAg
MTgxMMKgIMKgIMKgIMKgIMKgIGF0b21pY19zZXQoJmFtcDt0Y29uSW5mb0FsbG9jQ291bnQsIDAp
Ozxicj4NCsKgIDE4MTHCoCDCoCDCoCDCoCDCoCBhdG9taWNfc2V0KCZhbXA7dGNwU2VzTmV4dElk
LCAwKTs8YnI+DQrCoCAxODEywqAgwqAgwqAgwqAgwqAgYXRvbWljX3NldCgmYW1wO3RjcFNlc0Fs
bG9jQ291bnQsIDApOzxicj4NCsKgIDE4MTPCoCDCoCDCoCDCoCDCoCBhdG9taWNfc2V0KCZhbXA7
dGNwU2VzUmVjb25uZWN0Q291bnQsIDApOzxicj4NCsKgIDE4MTTCoCDCoCDCoCDCoCDCoCBhdG9t
aWNfc2V0KCZhbXA7dGNvbkluZm9SZWNvbm5lY3RDb3VudCwgMCk7PGJyPg0KwqAgMTgxNcKgIDxi
cj4NCsKgIDE4MTbCoCDCoCDCoCDCoCDCoCBhdG9taWNfc2V0KCZhbXA7YnVmX2FsbG9jX2NvdW50
LCAwKTs8YnI+DQrCoCAxODE3wqAgwqAgwqAgwqAgwqAgYXRvbWljX3NldCgmYW1wO3NtYWxsX2J1
Zl9hbGxvY19jb3VudCwgMCk7PGJyPg0KwqAgMTgxOMKgICNpZmRlZiBDT05GSUdfQ0lGU19TVEFU
UzI8YnI+DQrCoCAxODE5wqAgwqAgwqAgwqAgwqAgYXRvbWljX3NldCgmYW1wO3RvdGFsX2J1Zl9h
bGxvY19jb3VudCwgMCk7PGJyPg0KwqAgMTgyMMKgIMKgIMKgIMKgIMKgIGF0b21pY19zZXQoJmFt
cDt0b3RhbF9zbWFsbF9idWZfYWxsb2NfY291bnQsIDApOzxicj4NCsKgIDE4MjHCoCDCoCDCoCDC
oCDCoCBpZiAoc2xvd19yc3BfdGhyZXNob2xkICZsdDsgMSk8YnI+DQrCoCAxODIywqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgY2lmc19kYmcoRllJLCAmcXVvdDtzbG93X3Jlc3BvbnNlX3RocmVz
aG9sZCBtc2dzIGRpc2FibGVkXG4mcXVvdDspOzxicj4NCsKgIDE4MjPCoCDCoCDCoCDCoCDCoCBl
bHNlIGlmIChzbG93X3JzcF90aHJlc2hvbGQgJmd0OyAzMjc2Nyk8YnI+DQrCoCAxODI0wqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgY2lmc19kYmcoVkZTLDxicj4NCsKgIDE4MjXCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O3Nsb3cgcmVzcG9uc2UgdGhyZXNob2xk
IHNldCBoaWdoZXIgdGhhbiByZWNvbW1lbmRlZCAoMCB0byAzMjc2NylcbiZxdW90Oyk7PGJyPg0K
wqAgMTgyNsKgICNlbmRpZiAvKiBDT05GSUdfQ0lGU19TVEFUUzIgKi88YnI+DQrCoCAxODI3wqAg
PGJyPg0KwqAgMTgyOMKgIMKgIMKgIMKgIMKgIGF0b21pY19zZXQoJmFtcDttaWRfY291bnQsIDAp
Ozxicj4NCsKgIDE4MjnCoCDCoCDCoCDCoCDCoCBHbG9iYWxDdXJyZW50WGlkID0gMDs8YnI+DQrC
oCAxODMwwqAgwqAgwqAgwqAgwqAgR2xvYmFsVG90YWxBY3RpdmVYaWQgPSAwOzxicj4NCsKgIDE4
MzHCoCDCoCDCoCDCoCDCoCBHbG9iYWxNYXhBY3RpdmVYaWQgPSAwOzxicj4NCsKgIDE4MzLCoCDC
oCDCoCDCoCDCoCBzcGluX2xvY2tfaW5pdCgmYW1wO2NpZnNfdGNwX3Nlc19sb2NrKTs8YnI+DQrC
oCAxODMzwqAgwqAgwqAgwqAgwqAgc3Bpbl9sb2NrX2luaXQoJmFtcDtHbG9iYWxNaWRfTG9jayk7
PGJyPg0KwqAgMTgzNMKgIDxicj4NCsKgIDE4MzXCoCDCoCDCoCDCoCDCoCBjaWZzX2xvY2tfc2Vj
cmV0ID0gZ2V0X3JhbmRvbV91MzIoKTs8YnI+DQrCoCAxODM2wqAgPGJyPg0KwqAgMTgzN8KgIMKg
IMKgIMKgIMKgIGlmIChjaWZzX21heF9wZW5kaW5nICZsdDsgMikgezxicj4NCsKgIDE4MzjCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjaWZzX21heF9wZW5kaW5nID0gMjs8YnI+DQrCoCAxODM5
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgY2lmc19kYmcoRllJLCAmcXVvdDtjaWZzX21heF9w
ZW5kaW5nIHNldCB0byBtaW4gb2YgMlxuJnF1b3Q7KTs8YnI+DQrCoCAxODQwwqAgwqAgwqAgwqAg
wqAgfSBlbHNlIGlmIChjaWZzX21heF9wZW5kaW5nICZndDsgQ0lGU19NQVhfUkVRKSB7PGJyPg0K
wqAgMTg0McKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNpZnNfbWF4X3BlbmRpbmcgPSBDSUZT
X01BWF9SRVE7PGJyPg0KwqAgMTg0MsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNpZnNfZGJn
KEZZSSwgJnF1b3Q7Y2lmc19tYXhfcGVuZGluZyBzZXQgdG8gbWF4IG9mICV1XG4mcXVvdDssPGJy
Pg0KwqAgMTg0M8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgQ0lGU19N
QVhfUkVRKTs8YnI+DQrCoCAxODQ0wqAgwqAgwqAgwqAgwqAgfTxicj4NCsKgIDE4NDXCoCA8YnI+
DQrCoCAxODQ2wqAgwqAgwqAgwqAgwqAgLyogTGltaXQgbWF4IHRvIGFib3V0IDE4IGhvdXJzLCBh
bmQgc2V0dGluZyB0byB6ZXJvIGRpc2FibGVzIGRpcmVjdG9yeSBlbnRyeSBjYWNoaW5nICovPGJy
Pg0KwqAgMTg0N8KgIMKgIMKgIMKgIMKgIGlmIChkaXJfY2FjaGVfdGltZW91dCAmZ3Q7IDY1MDAw
KSB7PGJyPg0KwqAgMTg0OMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGRpcl9jYWNoZV90aW1l
b3V0ID0gNjUwMDA7PGJyPg0KwqAgMTg0OcKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGNpZnNf
ZGJnKFZGUywgJnF1b3Q7ZGlyX2NhY2hlX3RpbWVvdXQgc2V0IHRvIG1heCBvZiA2NTAwMCBzZWNv
bmRzXG4mcXVvdDspOzxicj4NCsKgIDE4NTDCoCDCoCDCoCDCoCDCoCB9PGJyPg0KwqAgMTg1McKg
IDxicj4NCsKgIDE4NTLCoCDCoCDCoCDCoCDCoCBjaWZzaW9kX3dxID0gYWxsb2Nfd29ya3F1ZXVl
KCZxdW90O2NpZnNpb2QmcXVvdDssIFdRX0ZSRUVaQUJMRXxXUV9NRU1fUkVDTEFJTSwgMCk7PGJy
Pg0KwqAgMTg1M8KgIMKgIMKgIMKgIMKgIGlmICghY2lmc2lvZF93cSkgezxicj4NCsKgIDE4NTTC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByYyA9IC1FTk9NRU07PGJyPg0KwqAgMTg1NcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIGdvdG8gb3V0X2NsZWFuX3Byb2M7PGJyPg0KPGJyPg0KR2Vu
ZXJhbGx5IEkgY2FuIHRlbGwgZnJvbSB0aGVzZSBnb3RvcyB0aGF0IHRoZXkgZnJlZSB0aGUgbGFz
dCByZXNvdXJjZS7CoCBUaGlzPGJyPg0Kb25lIGRlbGV0ZXMgdGhlIHByb2MgZmlsZXMuPGJyPg0K
PGJyPg0KwqAgMTg1NsKgIMKgIMKgIMKgIMKgIH08YnI+DQrCoCAxODU3wqAgPGJyPg0KwqAgMTg1
OMKgIMKgIMKgIMKgIMKgIC8qPGJyPg0KwqAgMTg1OcKgIMKgIMKgIMKgIMKgIMKgKiBDb25zaWRl
ciBpbiBmdXR1cmUgc2V0dGluZyBsaW1pdCE9MCBtYXliZSB0byBtaW4obnVtX29mX2NvcmVzIC0g
MSwgMyk8YnI+DQrCoCAxODYwwqAgwqAgwqAgwqAgwqAgwqAqIHNvIHRoYXQgd2UgZG9uJiMzOTt0
IGxhdW5jaCB0b28gbWFueSB3b3JrZXIgdGhyZWFkcyBidXQ8YnI+DQrCoCAxODYxwqAgwqAgwqAg
wqAgwqAgwqAqIERvY3VtZW50YXRpb24vY29yZS1hcGkvd29ya3F1ZXVlLnJzdCByZWNvbW1lbmRz
IHNldHRpbmcgaXQgdG8gMDxicj4NCsKgIDE4NjLCoCDCoCDCoCDCoCDCoCDCoCovPGJyPg0KwqAg
MTg2M8KgIDxicj4NCsKgIDE4NjTCoCDCoCDCoCDCoCDCoCAvKiBXUV9VTkJPVU5EIGFsbG93cyBk
ZWNyeXB0IHRhc2tzIHRvIHJ1biBvbiBhbnkgQ1BVICovPGJyPg0KwqAgMTg2NcKgIMKgIMKgIMKg
IMKgIGRlY3J5cHRfd3EgPSBhbGxvY193b3JrcXVldWUoJnF1b3Q7c21iM2RlY3J5cHRkJnF1b3Q7
LDxicj4NCsKgIDE4NjbCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoFdRX1VOQk9VTkR8V1FfRlJFRVpBQkxFfFdRX01FTV9SRUNMQUlNLCAw
KTs8YnI+DQrCoCAxODY3wqAgwqAgwqAgwqAgwqAgaWYgKCFkZWNyeXB0X3dxKSB7PGJyPg0KwqAg
MTg2OMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHJjID0gLUVOT01FTTs8YnI+DQrCoCAxODY5
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZ290byBvdXRfZGVzdHJveV9jaWZzaW9kX3dxOzxi
cj4NCjxicj4NCmNpZnNpb2Rfd3EgYWxsb2MgYW5kIGRlc3Ryb3llZC7CoCBGaW5lLjxicj4NCjxi
cj4NCsKgIDE4NzDCoCDCoCDCoCDCoCDCoCB9PGJyPg0KwqAgMTg3McKgIDxicj4NCsKgIDE4NzLC
oCDCoCDCoCDCoCDCoCBmaWxlaW5mb19wdXRfd3EgPSBhbGxvY193b3JrcXVldWUoJnF1b3Q7Y2lm
c2ZpbGVpbmZvcHV0JnF1b3Q7LDxicj4NCsKgIDE4NzPCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoFdRX1VOQk9VTkR8V1FfRlJFRVpBQkxF
fFdRX01FTV9SRUNMQUlNLCAwKTs8YnI+DQrCoCAxODc0wqAgwqAgwqAgwqAgwqAgaWYgKCFmaWxl
aW5mb19wdXRfd3EpIHs8YnI+DQrCoCAxODc1wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcmMg
PSAtRU5PTUVNOzxicj4NCsKgIDE4NzbCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBnb3RvIG91
dF9kZXN0cm95X2RlY3J5cHRfd3E7PGJyPg0KwqAgMTg3N8KgIMKgIMKgIMKgIMKgIH08YnI+DQrC
oCAxODc4wqAgPGJyPg0KwqAgMTg3OcKgIMKgIMKgIMKgIMKgIGNpZnNvcGxvY2tkX3dxID0gYWxs
b2Nfd29ya3F1ZXVlKCZxdW90O2NpZnNvcGxvY2tkJnF1b3Q7LDxicj4NCsKgIDE4ODDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oFdRX0ZSRUVaQUJMRXxXUV9NRU1fUkVDTEFJTSwgMCk7PGJyPg0KwqAgMTg4McKgIMKgIMKgIMKg
IMKgIGlmICghY2lmc29wbG9ja2Rfd3EpIHs8YnI+DQrCoCAxODgywqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgcmMgPSAtRU5PTUVNOzxicj4NCsKgIDE4ODPCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCBnb3RvIG91dF9kZXN0cm95X2ZpbGVpbmZvX3B1dF93cTs8YnI+DQrCoCAxODg0wqAgwqAg
wqAgwqAgwqAgfTxicj4NCsKgIDE4ODXCoCA8YnI+DQrCoCAxODg2wqAgwqAgwqAgwqAgwqAgZGVm
ZXJyZWRjbG9zZV93cSA9IGFsbG9jX3dvcmtxdWV1ZSgmcXVvdDtkZWZlcnJlZGNsb3NlJnF1b3Q7
LDxicj4NCsKgIDE4ODfCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoFdRX0ZSRUVaQUJMRXxXUV9NRU1fUkVDTEFJTSwgMCk7
PGJyPg0KwqAgMTg4OMKgIMKgIMKgIMKgIMKgIGlmICghZGVmZXJyZWRjbG9zZV93cSkgezxicj4N
CsKgIDE4ODnCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCByYyA9IC1FTk9NRU07PGJyPg0KwqAg
MTg5MMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGdvdG8gb3V0X2Rlc3Ryb3lfY2lmc29wbG9j
a2Rfd3E7PGJyPg0KwqAgMTg5McKgIMKgIMKgIMKgIMKgIH08YnI+DQrCoCAxODkywqAgPGJyPg0K
wqAgMTg5M8KgIMKgIMKgIMKgIMKgIHNlcnZlcmNsb3NlX3dxID0gYWxsb2Nfd29ya3F1ZXVlKCZx
dW90O3NlcnZlcmNsb3NlJnF1b3Q7LDxicj4NCsKgIDE4OTTCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoFdRX0ZSRUVaQUJM
RXxXUV9NRU1fUkVDTEFJTSwgMCk7PGJyPg0KwqAgMTg5NcKgIMKgIMKgIMKgIMKgIGlmICghc2Vy
dmVyY2xvc2Vfd3EpIHs8YnI+DQrCoCAxODk2wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgcmMg
PSAtRU5PTUVNOzxicj4NCsKgIDE4OTfCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBnb3RvIG91
dF9kZXN0cm95X3NlcnZlcmNsb3NlX3dxOzxicj4NCjxicj4NClRoaXMgc2hvdWxkIGJlIGdvdG8g
b3V0X2Rlc3Ryb3lfZGVmZXJyZWRjbG9zZV93cS48YnI+DQo8YnI+DQrCoCAxODk4wqAgwqAgwqAg
wqAgwqAgfTxicj4NCsKgIDE4OTnCoCA8YnI+DQrCoCAxOTAwwqAgwqAgwqAgwqAgwqAgcmMgPSBj
aWZzX2luaXRfaW5vZGVjYWNoZSgpOzxicj4NCsKgIDE5MDHCoCDCoCDCoCDCoCDCoCBpZiAocmMp
PGJyPg0KwqAgMTkwMsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGdvdG8gb3V0X2Rlc3Ryb3lf
ZGVmZXJyZWRjbG9zZV93cTs8YnI+DQo8YnI+DQpUaGlzIHNob3VsZCBiZSBvdXRfZGVzdHJveV9z
ZXJ2ZXJjbG9zZV93cS48YnI+DQo8YnI+DQrCoCAxOTAzwqAgPGJyPg0KwqAgMTkwNMKgIMKgIMKg
IMKgIMKgIHJjID0gY2lmc19pbml0X25ldGZzKCk7PGJyPg0KwqAgMTkwNcKgIMKgIMKgIMKgIMKg
IGlmIChyYyk8YnI+DQrCoCAxOTA2wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZ290byBvdXRf
ZGVzdHJveV9pbm9kZWNhY2hlOzxicj4NCsKgIDE5MDfCoCA8YnI+DQrCoCAxOTA4wqAgwqAgwqAg
wqAgwqAgcmMgPSBpbml0X21pZHMoKTs8YnI+DQrCoCAxOTA5wqAgwqAgwqAgwqAgwqAgaWYgKHJj
KTxicj4NCsKgIDE5MTDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBnb3RvIG91dF9kZXN0cm95
X25ldGZzOzxicj4NCsKgIDE5MTHCoCA8YnI+DQrCoCAxOTEywqAgwqAgwqAgwqAgwqAgcmMgPSBj
aWZzX2luaXRfcmVxdWVzdF9idWZzKCk7PGJyPg0KwqAgMTkxM8KgIMKgIMKgIMKgIMKgIGlmIChy
Yyk8YnI+DQrCoCAxOTE0wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgZ290byBvdXRfZGVzdHJv
eV9taWRzOzxicj4NCsKgIDE5MTXCoCA8YnI+DQrCoCAxOTE2wqAgI2lmZGVmIENPTkZJR19DSUZT
X0RGU19VUENBTEw8YnI+DQrCoCAxOTE3wqAgwqAgwqAgwqAgwqAgcmMgPSBkZnNfY2FjaGVfaW5p
dCgpOzxicj4NCsKgIDE5MTjCoCDCoCDCoCDCoCDCoCBpZiAocmMpPGJyPg0KwqAgMTkxOcKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIGdvdG8gb3V0X2Rlc3Ryb3lfcmVxdWVzdF9idWZzOzxicj4N
CsKgIDE5MjDCoCAjZW5kaWYgLyogQ09ORklHX0NJRlNfREZTX1VQQ0FMTCAqLzxicj4NCsKgIDE5
MjHCoCAjaWZkZWYgQ09ORklHX0NJRlNfVVBDQUxMPGJyPg0KwqAgMTkyMsKgIMKgIMKgIMKgIMKg
IHJjID0gaW5pdF9jaWZzX3NwbmVnbygpOzxicj4NCsKgIDE5MjPCoCDCoCDCoCDCoCDCoCBpZiAo
cmMpPGJyPg0KwqAgMTkyNMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGdvdG8gb3V0X2Rlc3Ry
b3lfZGZzX2NhY2hlOzxicj4NCsKgIDE5MjXCoCAjZW5kaWYgLyogQ09ORklHX0NJRlNfVVBDQUxM
ICovPGJyPg0KwqAgMTkyNsKgICNpZmRlZiBDT05GSUdfQ0lGU19TV05fVVBDQUxMPGJyPg0KwqAg
MTkyN8KgIMKgIMKgIMKgIMKgIHJjID0gY2lmc19nZW5sX2luaXQoKTs8YnI+DQrCoCAxOTI4wqAg
wqAgwqAgwqAgwqAgaWYgKHJjKTxicj4NCsKgIDE5MjnCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCBnb3RvIG91dF9yZWdpc3Rlcl9rZXlfdHlwZTs8YnI+DQo8YnI+DQpUaGlzIGdvdG8gaGFzIGEg
Y29uZnVzaW5nIG5hbWUuwqAgSXQgY2FsbHMgZXhpdF9jaWZzX3NwbmVnbygpLsKgIEl0IHVzZWQg
dG88YnI+DQp1bnJlZ2lzdGVyIHRoZSBzcGVnbm8ga2V5IHR5cGUuwqAgI0hpc3RvcmljYWxSZWFz
b25zPGJyPg0KPGJyPg0KwqAgMTkzMMKgICNlbmRpZiAvKiBDT05GSUdfQ0lGU19TV05fVVBDQUxM
ICovPGJyPg0KwqAgMTkzMcKgIDxicj4NCsKgIDE5MzLCoCDCoCDCoCDCoCDCoCByYyA9IGluaXRf
Y2lmc19pZG1hcCgpOzxicj4NCsKgIDE5MzPCoCDCoCDCoCDCoCDCoCBpZiAocmMpPGJyPg0KwqAg
MTkzNMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGdvdG8gb3V0X2NpZnNfc3duX2luaXQ7PGJy
Pg0KwqAgMTkzNcKgIDxicj4NCsKgIDE5MzbCoCDCoCDCoCDCoCDCoCByYyA9IHJlZ2lzdGVyX2Zp
bGVzeXN0ZW0oJmFtcDtjaWZzX2ZzX3R5cGUpOzxicj4NCsKgIDE5MzfCoCDCoCDCoCDCoCDCoCBp
ZiAocmMpPGJyPg0KwqAgMTkzOMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGdvdG8gb3V0X2lu
aXRfY2lmc19pZG1hcDs8YnI+DQrCoCAxOTM5wqAgPGJyPg0KwqAgMTk0MMKgIMKgIMKgIMKgIMKg
IHJjID0gcmVnaXN0ZXJfZmlsZXN5c3RlbSgmYW1wO3NtYjNfZnNfdHlwZSk7PGJyPg0KwqAgMTk0
McKgIMKgIMKgIMKgIMKgIGlmIChyYykgezxicj4NCsKgIDE5NDLCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCB1bnJlZ2lzdGVyX2ZpbGVzeXN0ZW0oJmFtcDtjaWZzX2ZzX3R5cGUpOzxicj4NCjxi
cj4NCkRvIHRoaXMgaW4gdGhlIHVud2luZCBsYWRkZXIsIG5vdCBiZWZvcmUgdGhlIGdvdG8uPGJy
Pg0KPGJyPg0KwqAgMTk0M8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGdvdG8gb3V0X2luaXRf
Y2lmc19pZG1hcDs8YnI+DQrCoCAxOTQ0wqAgwqAgwqAgwqAgwqAgfTxicj4NCsKgIDE5NDXCoCA8
YnI+DQrCoCAxOTQ2wqAgwqAgwqAgwqAgwqAgcmV0dXJuIDA7PGJyPg0KwqAgMTk0N8KgIDxicj4N
CsKgIDE5NDjCoCBvdXRfaW5pdF9jaWZzX2lkbWFwOjxicj4NCsKgIDE5NDnCoCDCoCDCoCDCoCDC
oCBleGl0X2NpZnNfaWRtYXAoKTs8YnI+DQrCoCAxOTUwwqAgb3V0X2NpZnNfc3duX2luaXQ6PGJy
Pg0KwqAgMTk1McKgICNpZmRlZiBDT05GSUdfQ0lGU19TV05fVVBDQUxMPGJyPg0KwqAgMTk1MsKg
IMKgIMKgIMKgIMKgIGNpZnNfZ2VubF9leGl0KCk7PGJyPg0KwqAgMTk1M8KgIG91dF9yZWdpc3Rl
cl9rZXlfdHlwZTo8YnI+DQrCoCAxOTU0wqAgI2VuZGlmPGJyPg0KwqAgMTk1NcKgICNpZmRlZiBD
T05GSUdfQ0lGU19VUENBTEw8YnI+DQrCoCAxOTU2wqAgwqAgwqAgwqAgwqAgZXhpdF9jaWZzX3Nw
bmVnbygpOzxicj4NCsKgIDE5NTfCoCBvdXRfZGVzdHJveV9kZnNfY2FjaGU6PGJyPg0KwqAgMTk1
OMKgICNlbmRpZjxicj4NCsKgIDE5NTnCoCAjaWZkZWYgQ09ORklHX0NJRlNfREZTX1VQQ0FMTDxi
cj4NCsKgIDE5NjDCoCDCoCDCoCDCoCDCoCBkZnNfY2FjaGVfZGVzdHJveSgpOzxicj4NCsKgIDE5
NjHCoCBvdXRfZGVzdHJveV9yZXF1ZXN0X2J1ZnM6PGJyPg0KwqAgMTk2MsKgICNlbmRpZjxicj4N
Cjxicj4NClRoZXNlIGlmZGVmIGFyZSBhIGJpdCBjb21wbGljYXRlZC7CoCBJdCBtaWdodCBiZSBu
aWNlciB0byB3cml0ZSBpdCBhczo8YnI+DQo8YnI+DQpvdXRfY2lmc19zd25faW5pdDo8YnI+DQrC
oCDCoCDCoCDCoCBpZiAoSVNfRU5BQkxFRChDT05GSUdfQ0lGU19TV05fVVBDQUxMKSk8YnI+DQrC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCBjaWZzX2dlbmxfZXhpdCgpOzxicj4NCjxicj4NCsKgIDE5
NjPCoCDCoCDCoCDCoCDCoCBjaWZzX2Rlc3Ryb3lfcmVxdWVzdF9idWZzKCk7PGJyPg0KwqAgMTk2
NMKgIG91dF9kZXN0cm95X21pZHM6PGJyPg0KwqAgMTk2NcKgIMKgIMKgIMKgIMKgIGRlc3Ryb3lf
bWlkcygpOzxicj4NCsKgIDE5NjbCoCBvdXRfZGVzdHJveV9uZXRmczo8YnI+DQrCoCAxOTY3wqAg
wqAgwqAgwqAgwqAgY2lmc19kZXN0cm95X25ldGZzKCk7PGJyPg0KwqAgMTk2OMKgIG91dF9kZXN0
cm95X2lub2RlY2FjaGU6PGJyPg0KwqAgMTk2OcKgIMKgIMKgIMKgIMKgIGNpZnNfZGVzdHJveV9p
bm9kZWNhY2hlKCk7PGJyPg0KwqAgMTk3MMKgIG91dF9kZXN0cm95X2RlZmVycmVkY2xvc2Vfd3E6
PGJyPg0KwqAgMTk3McKgIMKgIMKgIMKgIMKgIGRlc3Ryb3lfd29ya3F1ZXVlKGRlZmVycmVkY2xv
c2Vfd3EpOzxicj4NCsKgIDE5NzLCoCBvdXRfZGVzdHJveV9jaWZzb3Bsb2NrZF93cTo8YnI+DQrC
oCAxOTczwqAgwqAgwqAgwqAgwqAgZGVzdHJveV93b3JrcXVldWUoY2lmc29wbG9ja2Rfd3EpOzxi
cj4NCsKgIDE5NzTCoCBvdXRfZGVzdHJveV9maWxlaW5mb19wdXRfd3E6PGJyPg0KwqAgMTk3NcKg
IMKgIMKgIMKgIMKgIGRlc3Ryb3lfd29ya3F1ZXVlKGZpbGVpbmZvX3B1dF93cSk7PGJyPg0KwqAg
MTk3NsKgIG91dF9kZXN0cm95X2RlY3J5cHRfd3E6PGJyPg0KwqAgMTk3N8KgIMKgIMKgIMKgIMKg
IGRlc3Ryb3lfd29ya3F1ZXVlKGRlY3J5cHRfd3EpOzxicj4NCsKgIDE5NzjCoCBvdXRfZGVzdHJv
eV9jaWZzaW9kX3dxOjxicj4NCsKgIDE5NznCoCDCoCDCoCDCoCDCoCBkZXN0cm95X3dvcmtxdWV1
ZShjaWZzaW9kX3dxKTs8YnI+DQrCoCAxOTgwwqAgb3V0X2Rlc3Ryb3lfc2VydmVyY2xvc2Vfd3E6
PGJyPg0KwqAgMTk4McKgIMKgIMKgIMKgIMKgIGRlc3Ryb3lfd29ya3F1ZXVlKHNlcnZlcmNsb3Nl
X3dxKTs8YnI+DQrCoCAxOTgywqAgb3V0X2NsZWFuX3Byb2M6PGJyPg0KwqAgMTk4M8KgIMKgIMKg
IMKgIMKgIGNpZnNfcHJvY19jbGVhbigpOzxicj4NCjxicj4NClRoZXNlIG5lZWQgdG8gYmUgaW4g
bWlycm9yIG9yZGVyIGZyb20gaG93IHRoZXkgYXJlIGFsbG9jYXRlZC7CoCBUaGUgbGFzdCBzdGVw
IGlzPGJyPg0KdG8gY3V0IGFuZCBwYXN0ZSB0aGUgY2xlYW51cCBpbnRvIGV4aXRfY2lmcygpLCBh
ZGQgYW48YnI+DQp1bnJlZ2lzdGVyX2ZpbGVzeXN0ZW0oJmFtcDtzbWIzX2ZzX3R5cGUpOyBhbmQg
ZGVsZXRlIHRoZSBsYWJlbHMuwqAgVGhlcmUgaXMgYW4gZXh0cmE8YnI+DQpzdGVwIG9mIGNpZnNf
cmVsZWFzZV9hdXRvbW91bnRfdGltZXIoKSB3aGljaCBraWxscyB0aGUgdGltZXIuwqAgSSB3b3Vs
ZCBoYXZlPGJyPg0KZXhwZWN0ZWQgdGhhdCB0byBiZSB0aGUgZmlyc3QgdGhpbmcgaW4gdGhlIGZ1
bmN0aW9uLCBidXQgbWF5YmUgdGhlIG9yZGVyaW5nPGJyPg0KZG9lc24mIzM5O3QgbWF0dGVyIG9y
IG1heWJlIEkgaGF2ZW4mIzM5O3QgdW5kZXJzdG9vZCBob3cgdGhlIG9yZGVyaW5nIHdvcmtzLjxi
cj4NCjxicj4NCsKgIDE5ODTCoCDCoCDCoCDCoCDCoCByZXR1cm4gcmM7PGJyPg0KwqAgMTk4NcKg
IH08YnI+DQo8YnI+DQpyZWdhcmRzLDxicj4NCmRhbiBjYXJwZW50ZXI8YnI+DQo8YnI+DQo8L2Js
b2NrcXVvdGU+PC9kaXY+PGJyIGNsZWFyPSJhbGwiPjxkaXY+PGJyPjwvZGl2PjxzcGFuIGNsYXNz
PSJnbWFpbF9zaWduYXR1cmVfcHJlZml4Ij4tLSA8L3NwYW4+PGJyPjxkaXYgZGlyPSJsdHIiIGNs
YXNzPSJnbWFpbF9zaWduYXR1cmUiPlRoYW5rcyw8YnI+PGJyPlN0ZXZlPC9kaXY+DQo=
--00000000000048e180061dc83a5d--
--00000000000048e181061dc83a5f
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-fix-potential-null-pointer-use-in-destroy_workq.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-potential-null-pointer-use-in-destroy_workq.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lyw1lpbz0>
X-Attachment-Id: f_lyw1lpbz0

RnJvbSA4ZTJhMWRhMzIyN2E1OWZkZDJlYzZmYzJkZDM0NzU2MWIxNDQzMjdhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1pY3Jvc29mdC5jb20+
CkRhdGU6IFN1biwgMjEgSnVsIDIwMjQgMTU6NDU6NTYgLTA1MDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggcG90ZW50aWFsIG51bGwgcG9pbnRlciB1c2UgaW4gZGVzdHJveV93b3JrcXVldWUg
aW4KIGluaXRfY2lmcyBlcnJvciBwYXRoCgpEYW4gQ2FycGVudGVyIHJlcG9ydGVkIGEgU21hY2sg
c3RhdGljIGNoZWNrZXIgd2FybmluZzoKICAgZnMvc21iL2NsaWVudC9jaWZzZnMuYzoxOTgxIGlu
aXRfY2lmcygpCiAgIGVycm9yOiB3ZSBwcmV2aW91c2x5IGFzc3VtZWQgJ3NlcnZlcmNsb3NlX3dx
JyBjb3VsZCBiZSBudWxsIChzZWUgbGluZSAxODk1KQoKVGhlIHBhdGNoIHdoaWNoIGludHJvZHVj
ZWQgdGhlIHNlcnZlcmNsb3NlIHdvcmtxdWV1ZSB1c2VkIHRoZSB3cm9uZwpvcmVkZXJpbmcgaW4g
ZXJyb3IgcGF0aHMgaW4gaW5pdF9jaWZzKCkgZm9yIGZyZWVpbmcgaXQgb24gZXJyb3JzLgoKUmVw
b3J0ZWQtYnk6IERhbiBDYXJwZW50ZXIgPGRhbi5jYXJwZW50ZXJAbGluYXJvLm9yZz4KRml4ZXM6
IDE3MzIxN2JkNzMzNiAoInNtYjM6IHJldHJ5aW5nIG9uIGZhaWxlZCBzZXJ2ZXIgY2xvc2UiKQpD
Yzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwpDYzogUml0dmlrIEJ1ZGhpcmFqYSA8cmJ1ZGhpcmFq
YUBtaWNyb3NvZnQuY29tPgpTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNoQG1p
Y3Jvc29mdC5jb20+Ci0tLQogZnMvc21iL2NsaWVudC9jaWZzZnMuYyB8IDggKysrKy0tLS0KIDEg
ZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZnMvc21iL2NsaWVudC9jaWZzZnMuYyBiL2ZzL3NtYi9jbGllbnQvY2lmc2ZzLmMKaW5kZXgg
YzkyOTM3YmVkMTMzLi4yYzRiMzU3ZDg1ZTIgMTAwNjQ0Ci0tLSBhL2ZzL3NtYi9jbGllbnQvY2lm
c2ZzLmMKKysrIGIvZnMvc21iL2NsaWVudC9jaWZzZnMuYwpAQCAtMTg5NCwxMiArMTg5NCwxMiBA
QCBpbml0X2NpZnModm9pZCkKIAkJCQkJICAgV1FfRlJFRVpBQkxFfFdRX01FTV9SRUNMQUlNLCAw
KTsKIAlpZiAoIXNlcnZlcmNsb3NlX3dxKSB7CiAJCXJjID0gLUVOT01FTTsKLQkJZ290byBvdXRf
ZGVzdHJveV9zZXJ2ZXJjbG9zZV93cTsKKwkJZ290byBvdXRfZGVzdHJveV9kZWZlcnJlZGNsb3Nl
X3dxOwogCX0KIAogCXJjID0gY2lmc19pbml0X2lub2RlY2FjaGUoKTsKIAlpZiAocmMpCi0JCWdv
dG8gb3V0X2Rlc3Ryb3lfZGVmZXJyZWRjbG9zZV93cTsKKwkJZ290byBvdXRfZGVzdHJveV9zZXJ2
ZXJjbG9zZV93cTsKIAogCXJjID0gY2lmc19pbml0X25ldGZzKCk7CiAJaWYgKHJjKQpAQCAtMTk2
Nyw2ICsxOTY3LDggQEAgaW5pdF9jaWZzKHZvaWQpCiAJY2lmc19kZXN0cm95X25ldGZzKCk7CiBv
dXRfZGVzdHJveV9pbm9kZWNhY2hlOgogCWNpZnNfZGVzdHJveV9pbm9kZWNhY2hlKCk7CitvdXRf
ZGVzdHJveV9zZXJ2ZXJjbG9zZV93cToKKwlkZXN0cm95X3dvcmtxdWV1ZShzZXJ2ZXJjbG9zZV93
cSk7CiBvdXRfZGVzdHJveV9kZWZlcnJlZGNsb3NlX3dxOgogCWRlc3Ryb3lfd29ya3F1ZXVlKGRl
ZmVycmVkY2xvc2Vfd3EpOwogb3V0X2Rlc3Ryb3lfY2lmc29wbG9ja2Rfd3E6CkBAIC0xOTc3LDgg
KzE5NzksNiBAQCBpbml0X2NpZnModm9pZCkKIAlkZXN0cm95X3dvcmtxdWV1ZShkZWNyeXB0X3dx
KTsKIG91dF9kZXN0cm95X2NpZnNpb2Rfd3E6CiAJZGVzdHJveV93b3JrcXVldWUoY2lmc2lvZF93
cSk7Ci1vdXRfZGVzdHJveV9zZXJ2ZXJjbG9zZV93cToKLQlkZXN0cm95X3dvcmtxdWV1ZShzZXJ2
ZXJjbG9zZV93cSk7CiBvdXRfY2xlYW5fcHJvYzoKIAljaWZzX3Byb2NfY2xlYW4oKTsKIAlyZXR1
cm4gcmM7Ci0tIAoyLjQzLjAKCg==
--00000000000048e181061dc83a5f--
