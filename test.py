import argparse
import sec_helpers

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('domain', type=str, help='Domain to scan')
    parser.add_argument('type', type=str, help='Type (api or frontend')
    args = parser.parse_args()

    print('--------')
    print('Starting verification of desired http plaintext behaviour...')
    sec_helpers.NoHttp(domain=args.domain)

    print('--------')
    print('Starting HSTS max-age verification')
    sec_helpers.Hsts(domain=args.domain, age=10368000)

    print('--------')
    print('Starting TLS version test')
    sec_helpers.HighTls(domain=args.domain,
                        slide=args.domain.split('.')[-2] == 'appspot')

    if args.type == 'api':
        print('--------')
        print('Starting CORS Policy verification')
        sec_helpers.CorsPolicy(domain=args.domain)

    print('--------')
    print('Starting no SSL test')
    sec_helpers.NoSsl(domain=args.domain)
